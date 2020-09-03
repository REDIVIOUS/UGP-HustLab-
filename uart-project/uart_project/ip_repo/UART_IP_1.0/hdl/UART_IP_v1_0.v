
`timescale 1 ns / 1 ps

	module UART_IP_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here
		input wire sin, // RxD databit
		output wire sout, // TxD databit;
		output wire ready, // reciever has collected the full data
		output wire busy, // The status of data transmitting
		output wire errdata, // Check error of data
		output wire enderror, //Do not terminate 
		
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
	
	// intermidiate variable
	wire tx_clk_en, rx_clk_en; // enable the clock of TxD & RxD
	reg slv_reg0_in; // the register of AXI4-Lite (in data condition)
	wire slv_reg0_out; // the register of AXI4-Lite (out data condition)
    wire DisReg; // signal indicates that the reg has been read 
    wire write_enable = 0; // be able to transmit

	
// Instantiation of Axi Bus Interface S00_AXI
	UART_IP_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) UART_IP_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.slv_reg0_in(slv_reg0_in),
		.slv_reg0_out(slv_reg0_out),
		.ready(ready),
		.disreg(DisReg),
		.write_enable(write_enable)
	);

	// Add user logic here
	// instantiation of GenBuadRate
    GenBuadRate baud(.clk(s00_axi_aclk), .rst(s00_axi_aresetn), .tx_clk_en(tx_clk_en), .rx_clk_en(rx_clk_en));
    // instantiation of uart_tx
    uart_tx tx(.clk(s00_axi_aclk), .rst(s00_axi_aresetn), .tx_data(slv_reg0_in), .write_enable(write_enable), .tx_clk_en(tx_clk_en), .tx(sout), .busy(busy));
    // instantiation of uart_rx
    uart_rx rx(.clk(s00_axi_aclk), .rst(s00_axi_aresetn), .rx(sin), .state_clear(DisReg), .rx_clk_en(rx_clk_en), .ready(ready), .errdata(errdata), .enderror(enderror), .rx_data(slv_reg0_out));
	// User logic ends

	endmodule
