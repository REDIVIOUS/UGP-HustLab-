module baud_test();
/*baudgen模块的仿真*/

reg clk = 0; //输入时钟
reg rst = 1; //复位信号

wire tx_clk_en, rx_clk_en;

GenBuadRate baud(.clk(clk), .rst(rst), .tx_clk_en(tx_clk_en), .rx_clk_en(rx_clk_en));
always begin
    #1 clk = ~clk; //输入时钟的产生
end
endmodule