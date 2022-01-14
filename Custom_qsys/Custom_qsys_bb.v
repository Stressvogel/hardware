
module Custom_qsys (
	heartbeat_data_export,
	hrv_clock_clk,
	hrv_hex0_readdata,
	hrv_hex1_readdata,
	hrv_hex2_readdata,
	hrv_ledg_writeresponsevalid_n,
	hrv_ledr_readdata,
	ps2_CLK,
	ps2_DAT,
	pushbuttons_export,
	ref_clk_clk,
	ref_reset_reset,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	sram_DQ,
	sram_ADDR,
	sram_LB_N,
	sram_UB_N,
	sram_CE_N,
	sram_OE_N,
	sram_WE_N,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B);	

	input	[15:0]	heartbeat_data_export;
	input		hrv_clock_clk;
	output	[6:0]	hrv_hex0_readdata;
	output	[6:0]	hrv_hex1_readdata;
	output	[6:0]	hrv_hex2_readdata;
	output		hrv_ledg_writeresponsevalid_n;
	output	[15:0]	hrv_ledr_readdata;
	inout		ps2_CLK;
	inout		ps2_DAT;
	input	[3:0]	pushbuttons_export;
	input		ref_clk_clk;
	input		ref_reset_reset;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[31:0]	sdram_dq;
	output	[3:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	inout	[15:0]	sram_DQ;
	output	[19:0]	sram_ADDR;
	output		sram_LB_N;
	output		sram_UB_N;
	output		sram_CE_N;
	output		sram_OE_N;
	output		sram_WE_N;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
endmodule
