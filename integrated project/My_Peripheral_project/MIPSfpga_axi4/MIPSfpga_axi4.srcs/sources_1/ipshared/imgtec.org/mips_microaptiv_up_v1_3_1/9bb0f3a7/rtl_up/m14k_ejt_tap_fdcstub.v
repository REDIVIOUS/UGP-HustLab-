// mvp Version 2.24
// cmd line +define: MIPS_SIMULATION
// cmd line +define: MIPS_VMC_DUAL_INST
// cmd line +define: MIPS_VMC_INST
// cmd line +define: M14K_NO_ERROR_GEN
// cmd line +define: M14K_NO_SHADOW_CACHE_CHECK
// cmd line +define: M14K_TRACER_NO_FDCTRACE
//
//      Description: m14k_ejt_tap_fdcstub
//      EJTAG TAP FDCSTUB module
//
//      $Id: \$
//      mips_repository_id: m14k_ejt_tap_fdcstub.mv, v 1.4 
//
//      mips_start_of_legal_notice
//      **********************************************************************
//      Unpublished work (c) MIPS Technologies, Inc.  All rights reserved. 
//      Unpublished rights reserved under the copyright laws of the United
//      States of America and other countries.
//      
//      MIPS TECHNOLOGIES PROPRIETARY / RESTRICTED CONFIDENTIAL - HEIGHTENED
//      STANDARD OF CARE REQUIRED AS PER CONTRACT
//      
//      This code is confidential and proprietary to MIPS Technologies, Inc.
//      ("MIPS Technologies") and may be disclosed only as permitted in
//      writing by MIPS Technologies.  Any copying, reproducing, modifying,
//      use or disclosure of this code (in whole or in part) that is not
//      expressly permitted in writing by MIPS Technologies is strictly
//      prohibited.  At a minimum, this code is protected under trade secret,
//      unfair competition and copyright laws.	Violations thereof may result
//      in criminal penalties and fines.
//      
//      MIPS Technologies reserves the right to change the code to improve
//      function, design or otherwise.	MIPS Technologies does not assume any
//      liability arising out of the application or use of this code, or of
//      any error or omission in such code.  Any warranties, whether express,
//      statutory, implied or otherwise, including but not limited to the
//      implied warranties of merchantability or fitness for a particular
//      purpose, are excluded.	Except as expressly provided in any written
//      license agreement from MIPS Technologies, the furnishing of this code
//      does not give recipient any license to any intellectual property
//      rights, including any patent rights, that cover this code.
//      
//      This code shall not be exported, reexported, transferred, or released,
//      directly or indirectly, in violation of the law of any country or
//      international law, regulation, treaty, Executive Order, statute,
//      amendments or supplements thereto.  Should a conflict arise regarding
//      the export, reexport, transfer, or release of this code, the laws of
//      the United States of America shall be the governing law.
//      
//      This code may only be disclosed to the United States government
//      ("Government"), or to Government users, with prior written consent
//      from MIPS Technologies.  This code constitutes one or more of the
//      following: commercial computer software, commercial computer software
//      documentation or other commercial items.  If the user of this code, or
//      any related documentation of any kind, including related technical
//      data or manuals, is an agency, department, or other entity of the
//      Government, the use, duplication, reproduction, release, modification,
//      disclosure, or transfer of this code, or any related documentation of
//      any kind, is restricted in accordance with Federal Acquisition
//      Regulation 12.212 for civilian agencies and Defense Federal
//      Acquisition Regulation Supplement 227.7202 for military agencies.  The
//      use of this code by the Government is further restricted in accordance
//      with the terms of the license agreement(s) and/or applicable contract
//      terms and conditions covering this code from MIPS Technologies.
//      
//      
//      
//      **********************************************************************
//      mips_end_of_legal_notice
//

//verilint 240 off  // Unused input
`include "m14k_const.vh"

//verilint 528 off  // Variable set but not used.

module m14k_ejt_tap_fdcstub(
	gclk,
	gfclk,
	greset,
	gscanenable,
	cdmm_fdcread,
	cdmm_fdcgwrite,
	cdmm_fdc_hit,
	mmu_cdmm_kuc_m,
	AHB_EAddr,
	cdmm_wdata_xx,
	cpz_kuc_m,
	fdc_rdata_nxt,
	fdc_present,
	fdc_rxdata_tck,
	fdc_rxdata_rdy_tck,
	fdc_rxdata_ack_gclk,
	fdc_txdata_gclk,
	fdc_txdata_rdy_gclk,
	fdc_txdata_ack_tck,
	fdc_txtck_used_tck,
	fdc_rxint_tck,
	fdc_rxint_ack_gclk,
	ej_fdc_int,
	fdc_busy_xx);


   input         gclk;
   input         gfclk;
   input 	 greset;      
   input         gscanenable;         

     input 	cdmm_fdcread;
     input	cdmm_fdcgwrite;
     input	cdmm_fdc_hit;
     input	mmu_cdmm_kuc_m;
     input   [14:2]  AHB_EAddr;
     input [31:0] cdmm_wdata_xx;      
     input       cpz_kuc_m;
   output [31:0] fdc_rdata_nxt; // CDMM read data
   output	fdc_present;
   
   // Async signals to/from TCK module
   input [35:0]  fdc_rxdata_tck;       // Data value
   input 	 fdc_rxdata_rdy_tck;   // Data is ready
   output 	 fdc_rxdata_ack_gclk;  // Data has been accepted

   output [35:0] fdc_txdata_gclk;      // Data value
   output 	 fdc_txdata_rdy_gclk;  // Data is ready
   input 	 fdc_txdata_ack_tck;   // Data has been accepted

   input 	 fdc_txtck_used_tck;   // Tx TCK buffer occupied
   input 	 fdc_rxint_tck;        // FDC Interrupt Request
   output 	 fdc_rxint_ack_gclk;   // Int. Req. seen

   output 	 ej_fdc_int;       // Fast Debug Channel Interrupt
   output 	 fdc_busy_xx;          // Wakeup to transfer fast debug channel data

// BEGIN Wire declarations made by MVP
wire fdc_rxdata_ack_gclk;
wire ej_fdc_int;
wire fdc_busy_xx;
wire [35:0] /*[35:0]*/ fdc_txdata_gclk;
wire [31:0] /*[31:0]*/ fdc_rdata_nxt;
wire fdc_rxint_ack_gclk;
wire fdc_present;
wire fdc_txdata_rdy_gclk;
// END Wire declarations made by MVP


//
wire fdc_rx_read = 1'b0;
wire fdc_rxfull = 1'b0;
wire rx_array_empty = 1'b0;
wire tx_array_empty = 1'b0;
wire [35:0] rx_data_out = 36'b0;
wire tx_array_full = 1'b0;
wire fdc_rxfull_tap0 = 1'b0;
//

assign fdc_rdata_nxt[31:0] = 32'b0;
assign fdc_present =1'b0;
assign fdc_rxdata_ack_gclk = 1'b0;
assign fdc_txdata_gclk[35:0] = 36'b0;
assign fdc_txdata_rdy_gclk = 1'b0;
assign fdc_rxint_ack_gclk = 1'b0;
assign ej_fdc_int = 1'b0;
assign fdc_busy_xx =1'b0;
//verilint 240 on  // Unused input
endmodule
   
//verilint 528 on  // Variable set but not used.
