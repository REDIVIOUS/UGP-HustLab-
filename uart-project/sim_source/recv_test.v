module recv_test();
/*接收模块测试*/

wire [7:0] rx_data; //接收数据
reg clk = 0; //输入时钟
reg rst = 1; //复位
reg state_clear = 0; //要传输的数据位
reg databit; //当前传输的数据位
wire ready; //接收ready信号
wire errdata; //数据位错误指示
wire enderror; //帧错误指示（未正确结束）

wire rx_clk_en = 1;

uart_rx rx(.clk(clk), .rst(rst), .rx(databit), .state_clear(state_clear), .rx_clk_en(rx_clk_en), .ready(ready), .errdata(errdata), .enderror(enderror), .rx_data(rx_data));

initial begin
    // 数据正确的时候
    databit <= 0;
    #16 databit <= 1;
    
//    // 数据位错误的情况
//    databit <= 0;
//    #128 databit <= 1;
    
//    // 帧错误的情况
//    databit <= 0;
end

always begin //产生输入时钟
    #1 clk = ~clk;
end
endmodule