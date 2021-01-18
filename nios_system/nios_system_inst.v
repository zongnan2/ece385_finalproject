	nios_system u0 (
		.clk_clk          (<connected-to-clk_clk>),          //        clk.clk
		.key_wire_export  (<connected-to-key_wire_export>),  //   key_wire.export
		.mousex_export    (<connected-to-mousex_export>),    //     mousex.export
		.mousey_export    (<connected-to-mousey_export>),    //     mousey.export
		.pbutton_export   (<connected-to-pbutton_export>),   //    pbutton.export
		.reset_reset_n    (<connected-to-reset_reset_n>),    //      reset.reset_n
		.sdram_clk_clk    (<connected-to-sdram_clk_clk>),    //  sdram_clk.clk
		.sdram_wire_addr  (<connected-to-sdram_wire_addr>),  // sdram_wire.addr
		.sdram_wire_ba    (<connected-to-sdram_wire_ba>),    //           .ba
		.sdram_wire_cas_n (<connected-to-sdram_wire_cas_n>), //           .cas_n
		.sdram_wire_cke   (<connected-to-sdram_wire_cke>),   //           .cke
		.sdram_wire_cs_n  (<connected-to-sdram_wire_cs_n>),  //           .cs_n
		.sdram_wire_dq    (<connected-to-sdram_wire_dq>),    //           .dq
		.sdram_wire_dqm   (<connected-to-sdram_wire_dqm>),   //           .dqm
		.sdram_wire_ras_n (<connected-to-sdram_wire_ras_n>), //           .ras_n
		.sdram_wire_we_n  (<connected-to-sdram_wire_we_n>),  //           .we_n
		.usb_INT1         (<connected-to-usb_INT1>),         //        usb.INT1
		.usb_DATA         (<connected-to-usb_DATA>),         //           .DATA
		.usb_RST_N        (<connected-to-usb_RST_N>),        //           .RST_N
		.usb_ADDR         (<connected-to-usb_ADDR>),         //           .ADDR
		.usb_CS_N         (<connected-to-usb_CS_N>),         //           .CS_N
		.usb_RD_N         (<connected-to-usb_RD_N>),         //           .RD_N
		.usb_WR_N         (<connected-to-usb_WR_N>),         //           .WR_N
		.usb_INT0         (<connected-to-usb_INT0>)          //           .INT0
	);

