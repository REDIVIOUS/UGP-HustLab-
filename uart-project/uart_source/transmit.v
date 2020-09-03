module uart_tx(clk, rst, tx_data, write_enable, tx_clk_en, tx, busy);
input clk; //原始时钟(62MHz)
input rst; //复位
input [7:0] tx_data; //外部输入的数据
input write_enable; //外部给出的开始写信号
input tx_clk_en; ///发送方时钟使能
output reg tx = 0; //发送的数据
output reg busy = 0; //发送busy状态

reg [3:0] bit_count = 0; //发送数据的位
reg [7:0] temp_tx_data = 0; //发送数据的缓冲寄存器

// 状态机参数
parameter BEGIN = 3'b000; //发送起始位
parameter TRANSDATA = 3'b001; //发送数据位(1-7位)
parameter PARITY = 3'b010; //发送校验位(第8位)
parameter END = 3'b011; //发送结束位
parameter FREE = 3'b100; //空闲时期，等待写使能的到来

// 初始化state
reg [2:0] state = FREE;

// 需要将发送数据初始化为1
// 这一步很重要，如果不遵守，后面仿真的时候第一拍的时候tx=0，会提前开始
initial begin
    tx = 1;
end

always @(posedge clk) begin
    // 处理rst时候的动作
    if(!rst) begin
        state <= FREE; //状态变为空闲状态
        busy <= 0; //处于非busy状态
        bit_count <= 0; //当前发送位复位为0
        temp_tx_data <= 0; //清空发送缓存
    end
    // 处理数据发送时候的过程（状态机）
    case (state)
        BEGIN: begin // 发送起始位
            if(tx_clk_en) begin
                busy <= 1; //数据传输的busy状态
                tx <= 0; //开始标志位
                bit_count <= 0; //当前数据发送位置初始化位0
                state <= TRANSDATA; //状态转移到TRANSDATA，即发送数据
            end
        end
        TRANSDATA: begin //发送数据位1bit到7bit
            if(tx_clk_en) begin
                tx <= temp_tx_data[bit_count]; //将当前位置的数据发送
                if(bit_count == 6) begin
                    state <= PARITY; //状态转换到发送奇偶校验位
                end
                else begin
                    bit_count <= bit_count + 1; //接受下一个数据
                end
            end
        end
        PARITY: begin //发送奇偶校验位
            if(tx_clk_en) begin
                tx <= temp_tx_data[7]; //发送第8位，即校验位
                state <= END; //转到发送停止位
            end
        end
        END: begin //发送停止位
            if(tx_clk_en) begin
                tx <= 1;//发送停止位置
                state <= FREE; //转到空闲状态
            end
        end
        FREE: begin //空闲区
            busy <= 0; //没有数据传输，处于不busy的状态
            if (write_enable) begin //接收到写使能信号
                temp_tx_data <= tx_data; //将数据装入到发送数据寄存器中
                state <= BEGIN; //转到开始状态
            end
        end
        default: begin
            state <= FREE;
        end
    endcase
end
endmodule