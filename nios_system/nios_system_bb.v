
module nios_system (
	clk_clk,
	key_wire_export,
	mousex_export,
	mousey_export,
	pbutton_export,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	usb_INT1,
	usb_DATA,
	usb_RST_N,
	usb_ADDR,
	usb_CS_N,
	usb_RD_N,
	usb_WR_N,
	usb_INT0);	

	input		clk_clk;
	input	[3:0]	key_wire_export;
	output	[15:0]	mousex_export;
	output	[15:0]	mousey_export;
	output	[1:0]	pbutton_export;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input		usb_INT1;
	inout	[15:0]	usb_DATA;
	output		usb_RST_N;
	output	[1:0]	usb_ADDR;
	output		usb_CS_N;
	output		usb_RD_N;
	output		usb_WR_N;
	input		usb_INT0;
endmodule
