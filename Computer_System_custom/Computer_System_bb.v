
module Computer_System (
	flash_ADDR,
	flash_CE_N,
	flash_OE_N,
	flash_WE_N,
	flash_RST_N,
	flash_DQ,
	irda_TXD,
	irda_RXD,
	ps2_port_CLK,
	ps2_port_DAT,
	ps2_port_dual_CLK,
	ps2_port_dual_DAT,
	pushbuttons_export,
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
	system_pll_ref_clk_clk,
	system_pll_ref_reset_reset,
	usb_INT1,
	usb_DATA,
	usb_RST_N,
	usb_ADDR,
	usb_CS_N,
	usb_RD_N,
	usb_WR_N,
	usb_INT0,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B,
	video_pll_ref_clk_clk,
	video_pll_ref_reset_reset);	

	output	[22:0]	flash_ADDR;
	output		flash_CE_N;
	output		flash_OE_N;
	output		flash_WE_N;
	output		flash_RST_N;
	inout	[7:0]	flash_DQ;
	output		irda_TXD;
	input		irda_RXD;
	inout		ps2_port_CLK;
	inout		ps2_port_DAT;
	inout		ps2_port_dual_CLK;
	inout		ps2_port_dual_DAT;
	input	[3:0]	pushbuttons_export;
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
	input		system_pll_ref_clk_clk;
	input		system_pll_ref_reset_reset;
	input		usb_INT1;
	inout	[15:0]	usb_DATA;
	output		usb_RST_N;
	output	[1:0]	usb_ADDR;
	output		usb_CS_N;
	output		usb_RD_N;
	output		usb_WR_N;
	input		usb_INT0;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
	input		video_pll_ref_clk_clk;
	input		video_pll_ref_reset_reset;
endmodule
