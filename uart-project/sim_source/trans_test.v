module trans_test();
/*发送模块测试*/

reg [7:0] tx_data = 1; //发送数据
reg clk = 0; //输入时钟
reg rst = 1; //复位
reg write_enable = 0; //写使能
wire databit; //当前传输的数据位
wire busy; //发送busy信号

wire tx_clk_en = 1;


uart_tx tx(.clk(clk), .rst(rst), .tx_data(tx_data), .write_enable(write_enable), .tx_clk_en(tx_clk_en), .tx(databit), .busy(busy));

initial begin
    //发送数据3
    tx_data <= 3;
    //给出写使能信号，开始传输
    write_enable <= 1; 
    #2 write_enable <= 0;
    //发送数据15
    #100 tx_data<= 15;
    //给出写使能信号，开始传输
    write_enable <= 1;
    #2 write_enable <= 0; 
end

always begin //产生数额入时钟
    #1 clk = ~clk;
end
endmodule