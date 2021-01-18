// ECE 385 Final Project - Zuma inspired game implemenetaiton
// Created by Dylan Bentfield and Zongnan Chen

module final_project( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
				 // PS/2 Interface
				 inout wire				PS2_CLK,
				 inout wire				PS2_DAT,
				 // SRAM Interface
				 output logic [19:0] SRAM_ADDR,
				 inout wire [15:0]   SRAM_DQ,
				 output logic			SRAM_OE_N,
											SRAM_WE_N,
											SRAM_CE_N,
											SRAM_LB_N,
											SRAM_UB_N,
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK,     //SDRAM Clock
				 output logic [15:0] LEDR
                    );
    
    logic Reset_h, Clk, SRAM_CLK;
	 
	 // Color to draw to screen at a given pixel location
	 logic [4:0] palette;
	 
	 // Mouse values
    logic leftButton, rightButton, middleButton;
	 logic [9:0] cursorX, cursorY;
	 
	 // Vector values
	 logic [8:0] x_vector, y_vector;
	 
	 // Path and ball values
	 logic [9:0] Path_X_Pos[25:0], Path_Y_Pos[25:0], Path[25:0];
	 logic inserted, dead, win;
	 logic [9:0] DrawX, DrawY;
	 logic [9:0] ballX, ballY;
	 logic [1:0] ballColor;
	 
	 // SRAM values
	 logic sram_ready, sram_done, sram_write_en, render_sram_write_en;
	 logic render_sram_ready;
	 logic [19:0] sram_addr_in, render_sram_addr_in, frame_sram_addr_in, draw_location;
	 logic [15:0] sram_data_out, render_sram_data_in;
	 
	 // OCM Frame buffer values
	 logic ocm_write_en;
	 logic [18:0] ocm_write_addr, ocm_read_addr;
	 logic [4:0] fb2_out, fb_out;
	 
	 // Frame logic
	 logic buffer_select;
	 logic frame_clk_delayed, frame_clk_rising_edge, frame_clk, frame_counter;

	 logic [1:0] random_color;
	 logic [1:0] Game_State;
	 
	 // Scoring values
	 logic [4:0][3:0] dec_score;
	 logic [15:0] score;
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
	 
	 Mouse_interface mouse(.CLOCK_50(Clk), .KEY, .PS2_CLK, .PS2_DAT, .leftButton, .middleButton, .rightButton, .cursorX, .cursorY);
	 
	 // Determines the unit vectors for different positions of the mouse on the screen from the center
	 cursor_vector vectorizer(.Clk, .cursor_x(cursorX), .cursor_y(cursorY), .x_vector, .y_vector);


	/* =============================== */
	/* =====GRAPHICS RELATED CODE===== */
	/* =============================== */
	 decimal_score scorer(.Clk, .Reset(Reset_h), .score(score), .dec_score);
  
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
	 
	 sram_pll sram_clk_instance(.clk_clk(Clk), .reset_reset_n(~Reset_h), .sram_clk_clk(SRAM_CLK));
	 
	 frame_buffer f_buffer_2(.data_in(render_sram_data_in), .write_address(ocm_write_addr), .read_address(ocm_read_addr), .we(ocm_write_en), .Clk(Clk), .data_out(fb2_out));
	 mux2 #(5)palette_val(.s(buffer_select), .d0(sram_data_out[4:0]), .d1(fb2_out), .y(fb_out));
	 
	 // Frame buffer values
	 assign frame_clk = VGA_VS;
	 always_ff @ (posedge Clk) begin
		 frame_clk_delayed <= frame_clk;
		 frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
	 end
	 
	 always_comb
	 begin
		  draw_location = (DrawY * 20'd640) + DrawX;
	     if (buffer_select)
		  begin
			   // Read from OCM, write to SRAM
				//Reading
				ocm_read_addr = draw_location-1;
				ocm_write_en = 0;
				ocm_write_addr = 0;
				if (ocm_read_addr >= 307199)
					ocm_read_addr = 0;
				
				// Writing
		      sram_addr_in = render_sram_addr_in;
				sram_write_en = render_sram_write_en;
				sram_ready = render_sram_ready;
		  end
		  else
		  begin
				// Read from SRAM, write to OCM
				//Writing
				ocm_write_en = render_sram_write_en;
				ocm_write_addr = render_sram_addr_in[18:0];
				ocm_read_addr = 0;
				
				//Reading
				sram_addr_in = draw_location+1;
				sram_write_en = 0;
				sram_ready = 1;
				if (sram_addr_in >= 307199)
					sram_addr_in = 0;
		  end
	 end
	 
	 
	 sram_controller sram_controller_instance(
															.Clk,
															.Reset(Reset_h),
															.ready(sram_ready),
															.addr(sram_addr_in),
															.write_en(sram_write_en),
															.data_w(render_sram_data_in),
															.sram_data(SRAM_DQ),
															.done(sram_done),
															.sram_addr(SRAM_ADDR),
															.data(sram_data_out),
															.sram_oe_n(SRAM_OE_N),
															.sram_we_n(SRAM_WE_N),
															.sram_ce_n(SRAM_CE_N),
															.sram_lb_n(SRAM_LB_N),
															.sram_ub_n(SRAM_UB_N));
    VGA_controller vga_controller_instance(
														 .Clk,
														 .Reset(Reset_h),
														 .VGA_HS,
														 .VGA_VS,
														 .VGA_CLK,
														 .VGA_BLANK_N,
														 .VGA_SYNC_N,
														 .DrawX,
														 .DrawY);
														 
    color_mapper color_instance(.palette(fb_out), .VGA_R, .VGA_G, .VGA_B);
	 
	 frame_renderer renderer(.Clk,
									 .Reset(Reset_h),
									 .draw_frame(frame_clk_rising_edge),
									 .sram_ready(render_sram_ready),
									 .sram_write_en(render_sram_write_en),
									 .sram_addr_in(render_sram_addr_in),
									 .sram_data_in(render_sram_data_in),
									 .buffer_select,
									 .Game_State,
									 .*);
									 
	/* ================================= */
	/* =====Game Logic RELATED CODE===== */
	/* ================================= */
	 Shooter shooter_instance(.Clk,
									  .Reset(Reset_h),
									  .random(random_color),
									  .cursorX,
									  .cursorY,
									  .frame_clk,
									  .ballX,
									  .ballY,
									  .ballColor,
									  .x_vector,
									  .y_vector,
									  .leftButton,
									  .middleButton,
									  .rightButton,
									  .inserted,
									  .Game_State);
												 
	random_2 randomizer(.Clk(frame_clk), .Reset(Reset_h), .value(random_color));
	
	zuma zuma_game(.Clk, .Reset(Reset_h), .leftButton, .cursorX, .cursorY, .dead, .win, .Curr_State(Game_State));
	 
	/* =============================== */
	/* =======PATH RELATED CODE======= */
	/* =============================== */


//	assign Path_X_Pos = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd0, 10'd32, 10'd64, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000};
//	assign Path_Y_Pos = '{26{10'd400}};
//	assign Path = '{3'd1, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd1, 3'd2, 3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
	path game_path(.Clk,
						.frame_clk(frame_clk_rising_edge),
						.Reset(Reset_h),
						.Color_in({1'b0, ballColor} + 1),
						.Shooted_pos_X(ballX),
						.Shooted_pos_Y(ballY),
						.Path_X(Path_X_Pos),
						.Path_Y(Path_Y_Pos),
						.Path_Idx(Path),
						.inserted,
						.dead,
						.random_color,
						.score(score),
						.win,
						.Game_State);
	
	
	 
    // Display mouse information on hex display
//    HexDriver hex_inst_0 (cursorX[3:0], HEX0);
//    HexDriver hex_inst_1 (cursorX[7:4], HEX1);
//	 HexDriver hex_inst_2 ({2'b0, cursorX[9:8]}, HEX2);
//	 HexDriver hex_inst_3 ({1'b0, leftButton, middleButton, rightButton}, HEX3);
//    HexDriver hex_inst_0 (dec_score[0], HEX0);
//    HexDriver hex_inst_1 (dec_score[1], HEX1);
//	 HexDriver hex_inst_2 (dec_score[2], HEX2);
//	 HexDriver hex_inst_3 (dec_score[3], HEX3);
//	 HexDriver hex_inst_4 (dec_score[4], HEX4);
	 HexDriver hex_inst_0 (sram_data_out[3:0], HEX0);
    HexDriver hex_inst_1 (sram_data_out[7:4], HEX1);
	 HexDriver hex_inst_2 (sram_data_out[11:8], HEX2);
	 HexDriver hex_inst_3 (sram_data_out[15:12], HEX3);
	 HexDriver hex_inst_4 (dec_score[4], HEX4);
endmodule
