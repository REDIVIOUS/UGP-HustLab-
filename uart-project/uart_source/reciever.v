module uart_rx(clk, rst, rx, state_clear, rx_clk_en, ready, errdata, enderror, rx_data);
input clk; //原始时钟频率(62Hz)
input rst; //复位信号
input rx; //接收到的串行数据
input state_clear; //清除ready、errdata、enderror等信号
input rx_clk_en; //接收方时钟使能
output reg ready = 0; //准备接受信号
output reg errdata = 0; //数据校验出错
output reg enderror = 0; //停止位不正确（帧出错）
output reg [7:0] rx_data = 0; //接收到的数据

reg [3:0] clk_count = 0; //采样计数
reg [3:0] bit_count = 0; //接受数据的位
reg [7:0] temp_rx_data = 0; //接受到的数据缓冲
reg parity_result = 0; //计算校验结果

// 状态机参数
parameter BEGIN = 2'b00; //接收起始位
parameter TRANSDATA = 2'b01; //接收数据位(1-7位)
parameter PARITY = 2'b10; //接收校验位(第8位)
parameter END = 2'b11; //接收结束位

// 初始化state
reg [1:0] state = BEGIN;

always @(posedge clk) begin
    // 处理rst时候（复位信号）的动作
    if(!rst) begin
        state <= BEGIN; //开始状态
        ready <= 0; //ready信号初始化为0
        clk_count <= 0; //采样计数赋值为0
        bit_count <= 8'b0; //采样计数清0
        temp_rx_data <= 8'b0; //清空接收缓存
        rx_data <= 0; //接收数据清零
    end
    //清除ready、errdata、enderror等信号
    if(state_clear) begin
        ready <= 0;
        errdata <= 0;
        enderror <= 0;
    end
    if(rx_clk_en) begin //采样时钟
         case (state)
            // 接收起始位
            BEGIN: begin
                // 从遇到起位开始，开始接收
                if(rx == 0 || clk_count != 0) begin
                    clk_count <= clk_count + 1;
                end
                // 16个采样周期满，进行TRANSDATA阶段
                if(clk_count == 15) begin
                    state <= TRANSDATA; //转接收数据
                    // 采样计数、数据位、接收缓冲初始化
                    clk_count <= 0;
                    bit_count <= 0;
                    temp_rx_data <= 0;
                end
            end
            TRANSDATA: begin //接收数据位
                clk_count <= clk_count + 1; //采样计数加一
                if(clk_count == 8) begin //第8个采样周期开始采样
                    temp_rx_data[bit_count] <= rx; //当前接收位
                    // 计算校验位
                    if(bit_count == 0) begin
                        parity_result <= rx;
                    end
                    else begin
                        parity_result <= parity_result ^ rx; //计算校验位
                    end
                    bit_count <= bit_count + 1; //当前接收位加一
                end
                // 如果当前是第7位，则转到奇偶校验部分
                if(bit_count == 7 && clk_count == 15) begin
                    state <= PARITY;
                    clk_count <= 0; //开始重新计数，接收下一个
                end
            end
            PARITY: begin //接收校验位
                clk_count <= clk_count + 1;
                if(clk_count == 8) begin //第8个周期开始采样
                    temp_rx_data[bit_count] <= rx;
                    //采用偶校验
                    if(rx != parity_result) begin
                        errdata <= 1; //校验失败
                    end
                end
                if(bit_count == 7 && clk_count == 15) begin
                    state <= END; //接收停止位
                    clk_count <= 0; //采样16周期，计数器清零
                end
            end
            END: begin //接收结束位
                clk_count <= clk_count + 1;
                if(clk_count == 15) begin
                    rx_data <= temp_rx_data; //缓冲区数据输出
                    state <= BEGIN; //重新置于开始状态
                    ready <= 1'b1; //接收方接收数据ready，已经放入rx_data
                    clk_count <= 0; //采样计数清0
                end
                if(clk_count == 8 && rx == 0) begin ///读到了错误的终结位，置1
                    enderror <= 1; //帧错误
                end
            end
            default: begin
                state <= BEGIN;
            end
        endcase   
    end
end

endmodule