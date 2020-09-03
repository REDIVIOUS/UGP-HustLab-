// 一个BuadRate产生器，115200@62MHz
// 输入的时钟频率为50MHz，数据波特率为115200
// 接收方的采样时钟是数据波特率的16倍（以防接收方和发送方时钟存在偏差，一个数据采样16次）
// 分频系数 = 62*10^6/(115200*16) = 33，即接收方每33拍采样一次
// 62*10^6/115200 = 538，即发送方每538拍发送一次

module GenBuadRate(clk, rst, tx_clk_en, rx_clk_en);
input clk; //输入的时钟频率
input rst; //复位信号
output reg tx_clk_en = 0; //发送方时钟使能
output reg rx_clk_en = 0; //接收方时钟使能

reg [7:0] rx_baud_count = 0;  //计算接收方经过的输入时钟数目
reg [9:0] tx_baud_count = 0;  //计算发送方经过的输入时钟数目

always @(posedge clk) begin
    // 处理复位信号的情况
    if(!rst) begin
        // 计算经过的输入时钟数目清零
        rx_baud_count <= 8'h0;
        tx_baud_count <= 10'h0;
        // 两边时钟使能清零
        rx_clk_en <= 1'b0;
        tx_clk_en <= 1'b0;
    end
    // 处理接收端的时钟使能，每33拍采样一次(62MHz/(115200*16))，即采样时钟采用波特率的16倍
    if(rx_baud_count == 33) begin
        // 将count清0，接收方使能
        rx_baud_count <= 8'h0;
        rx_clk_en <= 1'b1;
    end
    else begin
       // 将count+1，接收方使能取消
       rx_baud_count <= rx_baud_count + 1;
       rx_clk_en <= 1'b0;
    end
    // 处理发送端的时钟使能，根据波特率为115200，每538拍取样一次(62MHz/115200=538)。
    if(tx_baud_count == 538) begin
       // 将count清0，发送方使能
       tx_baud_count <= 8'h0;
       tx_clk_en <= 1'b1;
    end
    else begin
       // 将count+1，发送方使能取消
       tx_baud_count <= tx_baud_count + 1;
       tx_clk_en <= 1'b0;
    end
end
endmodule
