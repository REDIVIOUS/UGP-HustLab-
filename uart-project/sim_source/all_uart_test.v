module test_uart();
/*整个串行通信模块的测试*/

reg [7:0] tx_data; //发送数据
wire [7:0] rx_data; //接收数据
reg clk = 0; //输入时钟
reg rst = 1; //复位
reg write_enable = 0; //写使能
reg state_clear = 0; //要传输的数据位
wire databit; //当前传输的数据位
wire ready; //接收ready信号
wire busy; //发送busy信号
wire errdata; //数据位错误指示
wire enderror; //帧错误指示（未正确结束）

wire tx_clk_en, rx_clk_en; //发送方和接收方的时钟使能
// 将发送数据拆成数据和校验位
reg [6:0] tx_data_data = 0;
reg tx_data_parity = 0;

GenBuadRate baud(.clk(clk), .rst(rst), .tx_clk_en(tx_clk_en), .rx_clk_en(rx_clk_en));
uart_tx tx(.clk(clk), .rst(rst), .tx_data(tx_data), .write_enable(write_enable), .tx_clk_en(tx_clk_en), .tx(databit), .busy(busy));
uart_rx rx(.clk(clk), .rst(rst), .rx(databit), .state_clear(state_clear), .rx_clk_en(rx_clk_en), .ready(ready), .errdata(errdata), .enderror(enderror), .rx_data(rx_data));

initial begin
    // 传送数字1，最高位是校验位，低7位是数据位
   tx_data_data = 1;
   tx_data_parity = ^tx_data_data;
   tx_data = {tx_data_parity, tx_data_data}; 
    // 开始传送（写使能）
    write_enable <= 1;
    #4 write_enable <= 0;
end

always begin
    #1 clk = ~clk; //输入时钟产生
end

// 接收ready信号到来，证明已经完成一次8bit数据的接收
// 接收方接收完毕，并且可以进行下一次传输
always @(posedge ready) begin
    // 捕捉到ready信号之后，清空ready、errdata、enderror信号
    #4 state_clear <= 1;
    #4 state_clear <= 0;
    // 我们传输的数据是从1到10，其中最高位是校验位，低7位是数据位
   if (tx_data_data <= 10) begin
        // 完成从1到10的数字的传送（带校验位，最后一位是校验位）
       tx_data_data = tx_data_data + 1;
       tx_data_parity = ^tx_data_data;
       tx_data = {tx_data_parity, tx_data_data}; 
        // 开启写使能，发送方进行传送
        write_enable <= 1;
        #4 write_enable <= 0;
    end
    else begin
       $finish;
    end
end
endmodule