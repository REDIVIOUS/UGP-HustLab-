// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//	Description: m14k_csramble_stub
//              Cache/SPRAM scramble stub module
//
//	$Id: \$
//	mips_repository_id: m14k_cscramble_stub.mv, v 1.8 
//


//	mips_start_of_legal_notice
//	***************************************************************************
//	Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//	Unpublished rights reserved under the copyright laws of the United States
//	of America and other countries.
//	
//	MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//	STANDARD OF CARE REQUIRED AS PER CONTRACT
//	
//	This code is confidential and proprietary to MIPS Technologies, Inc. ("MIPS
//	Technologies") and may be disclosed only as permitted in writing by MIPS
//	Technologies.  Any copying, reproducing, modifying, use or disclosure of
//	this code (in whole or in part) that is not expressly permitted in writing
//	by MIPS Technologies is strictly prohibited.  At a minimum, this code is
//	protected under trade secret, unfair competition and copyright laws. 
//	Violations thereof may result in criminal penalties and fines.
//	
//	MIPS Technologies reserves the right to change the code to improve
//	function, design or otherwise.	MIPS Technologies does not assume any
//	liability arising out of the application or use of this code, or of any
//	error or omission in such code.  Any warranties, whether express,
//	statutory, implied or otherwise, including but not limited to the implied
//	warranties of merchantability or fitness for a particular purpose, are
//	excluded.  Except as expressly provided in any written license agreement
//	from MIPS Technologies, the furnishing of this code does not give recipient
//	any license to any intellectual property rights, including any patent
//	rights, that cover this code.
//	
//	This code shall not be exported, reexported, transferred, or released,
//	directly or indirectly, in violation of the law of any country or
//	international law, regulation, treaty, Executive Order, statute, amendments
//	or supplements thereto.  Should a conflict arise regarding the export,
//	reexport, transfer, or release of this code, the laws of the United States
//	of America shall be the governing law.
//	
//	This code may only be disclosed to the United States government
//	("Government"), or to Government users, with prior written consent from
//	MIPS Technologies.  This code constitutes one or more of the following:
//	commercial computer software, commercial computer software documentation or
//	other commercial items.  If the user of this code, or any related
//	documentation of any kind, including related technical data or manuals, is
//	an agency, department, or other entity of the Government, the use,
//	duplication, reproduction, release, modification, disclosure, or transfer
//	of this code, or any related documentation of any kind, is restricted in
//	accordance with Federal Acquisition Regulation 12.212 for civilian agencies
//	and Defense Federal Acquisition Regulation Supplement 227.7202 for military
//	agencies.  The use of this code by the Government is further restricted in
//	accordance with the terms of the license agreement(s) and/or applicable
//	contract terms and conditions covering this code from MIPS Technologies.
//	
//	
//	
//	***************************************************************************
//	mips_end_of_legal_notice
//	

// Comments for verilint...Since the ports on this module need to match others,
//  some inputs are unused.
//verilint 240 off  // Unused input

`include "m14k_const.vh"

module m14k_cscramble_stub(
	greset,
	gclk,
	gscanenable,
	cfg_write,
	cfg_sel,
	cfg_data,
	dc_ws_addr,
	dc_ws_wr_mask,
	dc_ws_wr_data,
	dc_ws_rd_data,
	dc_tag_addr,
	dc_tag_wr_en,
	dc_tag_wr_data,
	dc_tag_rd_data,
	dc_data_addr,
	dc_wr_mask,
	dc_wr_data,
	dc_rd_data,
	dsp_data_addr,
	dsp_wr_mask,
	dsp_wr_par,
	dsp_wr_data,
	dsp_rd_par,
	dsp_rd_data,
	ic_ws_addr,
	ic_ws_wr_mask,
	ic_ws_wr_data,
	ic_ws_rd_data,
	ic_tag_addr,
	ic_tag_wr_en,
	ic_tag_wr_data,
	ic_tag_rd_data,
	ic_data_addr,
	ic_wr_mask,
	ic_rd_mask,
	ic_wr_data,
	ic_rd_data,
	isp_data_addr,
	isp_wr_par,
	isp_wr_data,
	isp_rd_par,
	isp_rd_data,
	icc_spwr_active,
	dc_ws_addr_scr,
	dc_ws_wr_mask_scr,
	dc_ws_wr_data_scr,
	dc_ws_rd_data_scr,
	dc_tag_addr_scr,
	dc_tag_wr_en_scr,
	dc_tag_wr_data_scr,
	dc_tag_rd_data_scr,
	dc_data_addr_scr,
	dc_wr_mask_scr,
	dc_wr_data_scr,
	dc_rd_data_scr,
	dsp_data_addr_scr,
	dsp_wr_mask_scr,
	dsp_wr_par_scr,
	dsp_wr_data_scr,
	dsp_rd_par_scr,
	dsp_rd_data_scr,
	ic_ws_addr_scr,
	ic_ws_wr_mask_scr,
	ic_ws_wr_data_scr,
	ic_ws_rd_data_scr,
	ic_tag_addr_scr,
	ic_tag_wr_en_scr,
	ic_tag_wr_data_scr,
	ic_tag_rd_data_scr,
	ic_data_addr_scr,
	ic_wr_mask_scr,
	ic_rd_mask_scr,
	ic_wr_data_scr,
	ic_rd_data_scr,
	isp_data_addr_scr,
	isp_wr_par_scr,
	isp_wr_data_scr,
	isp_rd_par_scr,
	isp_rd_data_scr,
	dc_ws_rd_str,
	dc_ws_wr_str,
	dc_tag_rd_str,
	dc_tag_wr_str,
	dc_data_rd_str,
	dc_data_wr_str,
	dsp_data_rd_str,
	dsp_data_wr_str,
	ic_ws_rd_str,
	ic_ws_wr_str,
	ic_tag_rd_str,
	ic_tag_wr_str,
	ic_data_rd_str,
	ic_data_wr_str,
	isp_data_rd_str,
	isp_data_wr_str);


// Instance Overridden Parameters
	parameter PARITY = `M14K_PARITY_ENABLE;
// Calculated Parameters
	parameter T_BITS = (PARITY == 1) ? `M14K_T_PAR_BITS : `M14K_T_NOPAR_BITS;
	parameter D_BITS = (PARITY == 1) ? `M14K_D_PAR_BITS : `M14K_D_NOPAR_BITS;

	input  greset;
	input  gclk;
	input  gscanenable;
	input  cfg_write;
	input  [7:0] cfg_sel;
	input  [31:0] cfg_data;

	input  [13:4] dc_ws_addr;
	input  [13:0] dc_ws_wr_mask;
	input  [13:0] dc_ws_wr_data;
	output [13:0] dc_ws_rd_data;
	input  [13:4] dc_tag_addr;
	input  [(`M14K_MAX_DC_ASSOC-1):0] dc_tag_wr_en;
	input  [(T_BITS-1):0] dc_tag_wr_data;
	output [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_tag_rd_data;
	input  [13:2] dc_data_addr;
	input  [(4*`M14K_MAX_DC_ASSOC-1):0]	dc_wr_mask;
	input  [(D_BITS-1):0] dc_wr_data;
	output [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_rd_data;
	input  [19:2] dsp_data_addr;
	input  [3:0] dsp_wr_mask;
	input  [3:0] dsp_wr_par;
	input  [31:0] dsp_wr_data;
	output [3:0] dsp_rd_par;
	output [31:0] dsp_rd_data;

	input  [13:4] ic_ws_addr;
	input  [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_mask;
	input  [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_data;
	output [(`M14K_MAX_IC_WS-1):0] ic_ws_rd_data;
	input  [13:4] ic_tag_addr;
	input  [(`M14K_MAX_IC_ASSOC-1):0] ic_tag_wr_en;
	input  [(T_BITS-1):0] ic_tag_wr_data;
	output [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_tag_rd_data;
	input  [13:2] ic_data_addr;
	input  [(4*`M14K_MAX_IC_ASSOC-1):0] ic_wr_mask;
	input  [(`M14K_MAX_IC_ASSOC-1):0] ic_rd_mask;
	input  [(D_BITS-1):0] ic_wr_data;
	output [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_rd_data;
	input  [19:2] isp_data_addr;
	input  [3:0] isp_wr_par;
	input  [31:0] isp_wr_data;
	output [3:0] isp_rd_par;
	output [31:0] isp_rd_data;
	input  icc_spwr_active;

	output [13:4] dc_ws_addr_scr;
	output [13:0] dc_ws_wr_mask_scr;
	output [13:0] dc_ws_wr_data_scr;
	input  [13:0] dc_ws_rd_data_scr;
	output [13:4] dc_tag_addr_scr;
	output [(`M14K_MAX_DC_ASSOC-1):0] dc_tag_wr_en_scr;
	output [(T_BITS-1):0] dc_tag_wr_data_scr;
	input  [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_tag_rd_data_scr;
	output [13:2] dc_data_addr_scr;
	output [(4*`M14K_MAX_DC_ASSOC-1):0] dc_wr_mask_scr;
	output [(D_BITS-1):0] dc_wr_data_scr;
	input  [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] dc_rd_data_scr;
	output [19:2] dsp_data_addr_scr;
	output [3:0] dsp_wr_mask_scr;
	output [3:0] dsp_wr_par_scr;
	output [31:0] dsp_wr_data_scr;
	input  [3:0] dsp_rd_par_scr;
	input  [31:0] dsp_rd_data_scr;

	output [13:4] ic_ws_addr_scr;
	output [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_mask_scr;
	output [(`M14K_MAX_IC_WS-1):0] ic_ws_wr_data_scr;
	input  [(`M14K_MAX_IC_WS-1):0] ic_ws_rd_data_scr;
	output [13:4] ic_tag_addr_scr;
	output [(`M14K_MAX_IC_ASSOC-1):0] ic_tag_wr_en_scr;
	output [(T_BITS-1):0] ic_tag_wr_data_scr;
	input  [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_tag_rd_data_scr;
	output [13:2] ic_data_addr_scr;
	output [(4*`M14K_MAX_IC_ASSOC-1):0] ic_wr_mask_scr;
	output [(`M14K_MAX_IC_ASSOC-1):0] ic_rd_mask_scr;
	output [(D_BITS-1):0] ic_wr_data_scr;
	input  [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] ic_rd_data_scr;
	output [19:2] isp_data_addr_scr;
	output [3:0] isp_wr_par_scr;
	output [31:0] isp_wr_data_scr;
	input  [3:0] isp_rd_par_scr;
	input  [31:0] isp_rd_data_scr;

	input  dc_ws_rd_str;
	input  dc_ws_wr_str;
	input  dc_tag_rd_str;
	input  dc_tag_wr_str;
	input  dc_data_rd_str;
	input  dc_data_wr_str;
	input  dsp_data_rd_str;
	input  dsp_data_wr_str;
	input  ic_ws_rd_str;
	input  ic_ws_wr_str;
	input  ic_tag_rd_str;
	input  ic_tag_wr_str;
	input  ic_data_rd_str;
	input  ic_data_wr_str;
	input  isp_data_rd_str;
	input  isp_data_wr_str;

// BEGIN Wire declarations made by MVP
wire [(4*`M14K_MAX_IC_ASSOC-1):0] /*[15:0]*/ ic_wr_mask_scr;
wire [(4*`M14K_MAX_DC_ASSOC-1):0] /*[15:0]*/ dc_wr_mask_scr;
wire [3:0] /*[3:0]*/ dsp_wr_par_scr;
wire [(`M14K_MAX_IC_ASSOC-1):0] /*[3:0]*/ ic_tag_wr_en_scr;
wire [13:0] /*[13:0]*/ dc_ws_wr_mask_scr;
wire [3:0] /*[3:0]*/ dsp_rd_par;
wire [13:0] /*[13:0]*/ dc_ws_wr_data_scr;
wire [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] /*[143:0]*/ dc_rd_data;
wire [31:0] /*[31:0]*/ dsp_wr_data_scr;
wire [(D_BITS-1):0] /*[35:0]*/ ic_wr_data_scr;
wire [(T_BITS-1):0] /*[24:0]*/ ic_tag_wr_data_scr;
wire [3:0] /*[3:0]*/ isp_wr_par_scr;
wire [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] /*[143:0]*/ ic_rd_data;
wire [13:4] /*[13:4]*/ ic_tag_addr_scr;
wire [(D_BITS-1):0] /*[35:0]*/ dc_wr_data_scr;
wire [13:4] /*[13:4]*/ dc_ws_addr_scr;
wire [19:2] /*[19:2]*/ isp_data_addr_scr;
wire [13:2] /*[13:2]*/ ic_data_addr_scr;
wire [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] /*[99:0]*/ ic_tag_rd_data;
wire [13:4] /*[13:4]*/ dc_tag_addr_scr;
wire [3:0] /*[3:0]*/ isp_rd_par;
wire [19:2] /*[19:2]*/ dsp_data_addr_scr;
wire [31:0] /*[31:0]*/ dsp_rd_data;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ ic_ws_wr_data_scr;
wire [13:0] /*[13:0]*/ dc_ws_rd_data;
wire [13:4] /*[13:4]*/ ic_ws_addr_scr;
wire [3:0] /*[3:0]*/ dsp_wr_mask_scr;
wire [(`M14K_MAX_DC_ASSOC-1):0] /*[3:0]*/ dc_tag_wr_en_scr;
wire [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] /*[99:0]*/ dc_tag_rd_data;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ ic_ws_wr_mask_scr;
wire [13:2] /*[13:2]*/ dc_data_addr_scr;
wire [(`M14K_MAX_IC_WS-1):0] /*[5:0]*/ ic_ws_rd_data;
wire [(T_BITS-1):0] /*[24:0]*/ dc_tag_wr_data_scr;
wire [(`M14K_MAX_IC_ASSOC-1):0] /*[3:0]*/ ic_rd_mask_scr;
wire [31:0] /*[31:0]*/ isp_wr_data_scr;
wire [31:0] /*[31:0]*/ isp_rd_data;
// END Wire declarations made by MVP


	/* End of I/O */

	assign dc_ws_addr_scr [13:4] = dc_ws_addr;
	assign dc_ws_wr_mask_scr [13:0] = dc_ws_wr_mask;
	assign dc_ws_wr_data_scr [13:0] = dc_ws_wr_data;
	assign dc_ws_rd_data [13:0] = dc_ws_rd_data_scr;
	assign dc_tag_addr_scr [13:4] = dc_tag_addr;
	assign dc_tag_wr_en_scr [(`M14K_MAX_DC_ASSOC-1):0] = dc_tag_wr_en;
	assign dc_tag_wr_data_scr [(T_BITS-1):0] = dc_tag_wr_data;
	assign dc_tag_rd_data [(T_BITS*`M14K_MAX_DC_ASSOC-1):0] = dc_tag_rd_data_scr;
	assign dc_data_addr_scr [13:2] = dc_data_addr;
	assign dc_wr_mask_scr [(4*`M14K_MAX_DC_ASSOC-1):0] = dc_wr_mask;
	assign dc_wr_data_scr [(D_BITS-1):0] = dc_wr_data;
	assign dc_rd_data [(D_BITS*`M14K_MAX_DC_ASSOC-1):0] = dc_rd_data_scr;
	assign dsp_data_addr_scr [19:2] = dsp_data_addr;
	assign dsp_wr_mask_scr [3:0] = dsp_wr_mask;
	assign dsp_wr_par_scr [3:0] = dsp_wr_par;
	assign dsp_wr_data_scr [31:0] = dsp_wr_data;
	assign dsp_rd_par [3:0] = dsp_rd_par_scr;
	assign dsp_rd_data [31:0] = dsp_rd_data_scr;

	assign ic_ws_addr_scr [13:4] = ic_ws_addr;
	assign ic_ws_wr_mask_scr [(`M14K_MAX_IC_WS-1):0] = ic_ws_wr_mask;
	assign ic_ws_wr_data_scr [(`M14K_MAX_IC_WS-1):0] = ic_ws_wr_data;
	assign ic_ws_rd_data [(`M14K_MAX_IC_WS-1):0] = ic_ws_rd_data_scr;
	assign ic_tag_addr_scr [13:4] = ic_tag_addr;
	assign ic_tag_wr_en_scr [(`M14K_MAX_IC_ASSOC-1):0] = ic_tag_wr_en;
	assign ic_tag_wr_data_scr [(T_BITS-1):0] = ic_tag_wr_data;
	assign ic_tag_rd_data [(T_BITS*`M14K_MAX_IC_ASSOC-1):0] = ic_tag_rd_data_scr;
	assign ic_data_addr_scr [13:2] = ic_data_addr;
	assign ic_wr_mask_scr [(4*`M14K_MAX_IC_ASSOC-1):0] = ic_wr_mask;
	assign ic_rd_mask_scr [(`M14K_MAX_IC_ASSOC-1):0] = ic_rd_mask;
	assign ic_wr_data_scr [(D_BITS-1):0] = ic_wr_data;
	assign ic_rd_data [(D_BITS*`M14K_MAX_IC_ASSOC-1):0] = ic_rd_data_scr;
	assign isp_data_addr_scr [19:2] = isp_data_addr;
	assign isp_wr_par_scr [3:0] = isp_wr_par;
	assign isp_wr_data_scr [31:0] = isp_wr_data;
	assign isp_rd_par [3:0] = isp_rd_par_scr;
	assign isp_rd_data [31:0] = isp_rd_data_scr;

//verilint 240 on  // Unused input
endmodule

