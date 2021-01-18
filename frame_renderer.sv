// Frame Renderer

module frame_renderer
(
	input Clk,
	input Reset,
	input draw_frame,
	input [9:0] ballX, ballY,
	input [1:0] ballColor,
	input [9:0] cursorX, cursorY,
	input [15:0] sram_data_out,
	input [4:0][3:0] dec_score,
	input [9:0] Path_X_Pos[25:0],
					Path_Y_Pos[25:0],
					Path[25:0],
	input [1:0] Game_State,
	output logic sram_ready, sram_write_en,
	output logic buffer_select,
	output logic [19:0] sram_addr_in,
	output logic [15:0] sram_data_in
);

logic [19:0] counter, counter_in;
logic [7:0] sprite_width, sprite_height;
logic [7:0] sprite_width_in, sprite_height_in;

logic [18:0] sprite_readaddr;
logic [4:0] sprite_data, palette_choice;
logic buffer_select_in;

logic [9:0] Path_X_Pos_Buffer [25:0],
				Path_Y_Pos_Buffer [25:0],
				Path_Buffer [25:0];

localparam BALL_SPRITE = 32;
localparam BUFFER_OFFSET = 307200;


enum logic [5:0] {
	Done,
	Wait,
	Background_Setup,
	Background,
	Background_Fetch,
	Path_BG_Setup,
	Path_BG_Setup_2,
	Path_BG_Fetch,
	Path_BG,
	Path_End_Setup,
	Path_End_Fetch,
	Path_End,
	Path_FG_Fetch,
	Path_FG,
	Shooted_Setup,
	Shooted,
	Shooted_Fetch,
	Shooter_Base_Setup,
	Shooter_Base_Fetch,
	Shooter_Base,
//	Shooter_Top_Setup,
//	Shooter_Top_Fetch,
//	Shooter_Top,
	Score_Setup,
	Score_Setup_2,
	Score_Fetch,
	Score,
	Score_Dec_Fetch,
	Score_Dec,
	Button_Start_Setup,
	Button_GameOver_Setup,
	Button_Fetch,
	Button,
	Mouse_Setup,
	Mouse,
	Mouse_Fetch
} State, Next_State;

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Done;
		counter <= 0;
		buffer_select <= 0;
		pixel_start <= 0;
		sprite_width <= 0;
		sprite_height <= 0;
	end
	else
	begin
		State <= Next_State;
		counter <= counter_in;
		buffer_select <= buffer_select_in;
		pixel_start <= pixel_start_in;
		sprite_width <= sprite_width_in;
		sprite_height <= sprite_height_in;
	end
	Path_X_Pos_Buffer <= Path_X_Pos; // Maybe move this to only on frame_clk rising edge? Or maybe not needed at all?
	Path_Y_Pos_Buffer <= Path_Y_Pos;
	Path_Buffer <= Path;
end
logic [20:0] count;

always_comb
begin
	Next_State = State;
	counter_in = counter;
	sram_ready = 1'b0;
	sram_write_en = 1'b0;
	sram_data_in = 16'b0;
	sram_addr_in = 20'b0;
	buffer_select_in = buffer_select;
	pixel_at = 0;
	pixel_start_in = pixel_start;
	sprite_width_in = sprite_width;
	sprite_height_in = sprite_height;
	use_score_start = 0;
	use_score_digit = 0;
	use_ball_start = 0;
	use_shot_ball_addr = 0;

	unique case (State)
		Done:
		begin
			if (draw_frame)
				Next_State = Wait;
		end
		Wait:
		begin
			Next_State = Background_Setup;
		end
		Background_Setup:
		begin
			Next_State = Background_Fetch;
		end
		Background:
		begin
			Next_State = Background_Fetch;
		end
		Background_Fetch:
		begin
			if (counter >= 20'd307_200)
			begin
				Next_State = Path_BG_Setup;
				counter_in = 0;
			end
			else
				Next_State = Background;
		end
		Shooted_Setup:
		begin
			Next_State = Shooted_Fetch;
		end
		Shooted_Fetch:
		begin
			if (counter >= 1023)
			begin
				Next_State = Score_Setup;
				counter_in = 0;
			end
			else
				Next_State = Shooted;
		end
		Shooted:
		begin
			Next_State = Shooted_Fetch;
		end
		Mouse_Setup:
		begin
			Next_State = Mouse_Fetch;
		end
		Mouse_Fetch:
		begin
			if (counter >= 20'd63)
			begin
				Next_State = Done;
				counter_in = 0;
			end
			else
				Next_State = Mouse;
		end
		Mouse:
		begin
			Next_State = Mouse_Fetch;
		end
		Shooter_Base_Setup:
			Next_State = Shooter_Base_Fetch;
		Shooter_Base_Fetch:
		begin
			if (counter >= 20'd4095)
			begin
				Next_State = Shooted_Setup;
				counter_in = 0;
			end
			else
				Next_State = Shooter_Base;
		end
		Shooter_Base:
			Next_State = Shooter_Base_Fetch;
//		Shooter_Top_Setup:
//			Next_State = Shooter_Top_Fetch;
//		Shooter_Top_Fetch:
//		begin
//			if (counter >= 20'd4095)
//			begin
//				Next_State = Score_Setup;
//				counter_in = 0;
//			end
//			else
//				Next_State = Shooter_Top;
//		end
//		Shooter_Top:
//			Next_State = Shooter_Top_Fetch;
		Score_Setup:
			Next_State = Score_Setup_2;
		Score_Setup_2:
			Next_State = Score_Fetch;
		Score_Fetch:
		begin
			if (counter >= 20'd319)
			begin
				Next_State = Score_Dec_Fetch;
				counter_in = 0;
			end
			else
				Next_State = Score;
		end
		Score:
			Next_State = Score_Fetch;
		Score_Dec_Fetch:
		begin
			if (counter >= 20'd319)
			begin
				if (Game_State == 2'b0)
				begin
					Next_State = Button_Start_Setup;
				end
				else if (Game_State == 2'd2)
				begin
					Next_State = Button_GameOver_Setup;
				end
				else
				begin
					Next_State = Mouse_Setup;
				end
				counter_in = 0;
			end
			else
				Next_State = Score_Dec;
		end
		Score_Dec:
			Next_State = Score_Dec_Fetch;
		Path_BG_Setup:
			Next_State = Path_BG_Setup_2;
		Path_BG_Setup_2:
			Next_State = Path_BG_Fetch;
		Path_BG_Fetch:
		begin
			if (counter >= 20'd20_479)
			begin
				Next_State = Path_End_Setup;
				counter_in = 0;
			end
			else
				Next_State = Path_BG;
		end
		Path_BG:
			Next_State = Path_BG_Fetch;
		Path_FG_Fetch:
		begin
			if (counter >= 20'd26_623)
			begin
				Next_State = Shooter_Base_Setup;
				counter_in = 0;
			end
			else
				Next_State = Path_FG;
		end
		Path_FG:
			Next_State = Path_FG_Fetch;
		Path_End_Setup:
			Next_State = Path_End_Fetch;
		Path_End_Fetch:
		begin
			if (counter >= 20'd1_023)
			begin
				Next_State = Path_FG_Fetch;
				counter_in = 0;
			end
			else
				Next_State = Path_End;
		end
		Path_End:
			Next_State = Path_End_Fetch;
		Button_Start_Setup:
			Next_State = Button_Fetch;
		Button_GameOver_Setup:
			Next_State = Button_Fetch;
		Button_Fetch:
		begin
			if (counter >= 20'd2_047)
			begin
				Next_State = Mouse_Setup;
				counter_in = 0;
			end
			else
				Next_State = Button;
		end
		Button:
		begin
			Next_State = Button_Fetch;
		end
		default: ;
	endcase
	
	case (State)
		Done:
		begin
			counter_in = 0;
		end
		Wait:
		begin
			counter_in = 0;
			buffer_select_in = ~buffer_select;
		end
		Background_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd32;
			pixel_start_in = 20'd16_672;
			
		end
		Background_Fetch:
		begin
			pixel_at = (((counter / 20'd640) % 8'd32) << 8'd5) + (counter % 32);
		end
		Background:
		begin
			sram_addr_in = counter;
			sram_data_in = sprite_data;
			sram_write_en = 1'b1;
			sram_ready = 1'b1;
			counter_in = counter + 1;
		end
		Shooted_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd32;
			use_shot_ball_addr = 1'b1;
		end
		Shooted_Fetch:
		begin
			use_shot_ball_addr = 1'b1;
			pixel_at = counter;
		end
		Shooted:
		begin
			sram_addr_in = (((ballY-16) + (counter/32)) * 20'd640) + (ballX-16) + (counter%32);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Mouse_Setup:
		begin
			sprite_height_in = 8'd8;
			sprite_width_in = 8'd8;
			pixel_start_in = 20'd10_336;
			pixel_at = 0;
		end
		Mouse_Fetch, Path_End_Fetch:
		begin
			pixel_at = counter;
		end
		Mouse:
		begin
			sram_addr_in = ((cursorY + (counter>>3)) * 20'd640) + cursorX + (counter%8);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Shooter_Base_Setup:
		begin
			sprite_height_in = 8'd64;
			sprite_width_in = 8'd64;
			pixel_start_in = 20'd32;
		end
		Shooter_Base_Fetch://, Shooter_Top_Fetch:
		begin
			pixel_at = counter;
		end
		Shooter_Base://, Shooter_Top:
		begin
			sram_addr_in = ((20'd208 + (counter>>6)) * 20'd640) + 20'd288 + (counter%64);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
//		Shooter_Top_Setup:
//		begin
//			sprite_height_in = 8'd64;
//			sprite_width_in = 8'd64;
//			pixel_start_in = 20'd96;
//		end
		Score_Setup:
		begin
			sprite_height_in = 8'd8;
			sprite_width_in = 8'd8;
		end
		Score_Fetch:
		begin
			pixel_at = (counter & 20'b0111111);
			use_score_start = 1;
		end
		Score:
		begin
			// Offset of 20 for y and x start position
			sram_addr_in = ((20'd20 + ((counter & 20'b0111111) >> 3)) * 20'd640) + 20'd20 + ((counter >> 6) << 3) + (counter & 20'b0111);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Score_Dec_Fetch:
		begin
			pixel_at = (counter & 20'b0111111);
			use_score_digit = 1;
		end
		Score_Dec:
		begin
			sram_addr_in = ((20'd20 + ((counter & 20'b0111111) >> 3)) * 20'd640) + 20'd68 + ((4-(counter >> 6)) << 3) + (counter & 20'b0111);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Path_BG_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd32;
			pixel_start_in = 20'd20_480;
		end
		Path_BG_Fetch:
		begin
			pixel_at = (counter & 20'b01111111111);
		end
		Path_BG:
		begin
			sram_addr_in = ((20'd400 + ((counter & 20'b01111111111)>>5)) * 20'd640) + ((counter >> 10) << 5) + (counter & 20'b011111);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Path_FG_Fetch:
		begin
			use_ball_start = 1;
			pixel_at = (counter & 20'b01111111111);
		end
		Path_FG:
		begin
			if ((Path_Buffer[current_ball] > 1'b0) && (Path_X_Pos_Buffer[current_ball] >= 1'b0) && (Path_X_Pos_Buffer[current_ball] <= 10'd640))
			begin
				sram_addr_in = (((Path_Y_Pos_Buffer[current_ball]) + ((counter & 20'b01111111111) >> 5)) * 20'd640) + Path_X_Pos_Buffer[current_ball] + (counter & 20'b011111);
				sram_data_in = sprite_data;
				if (sram_data_in != 0)
				begin
					sram_write_en = 1'b1;
					sram_ready = 1'b1;
				end
			end
			counter_in = counter + 1;
		end
		Path_End_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd32;
			pixel_start_in = 20'd20_544;
		end
		Path_End:
		begin
			sram_addr_in = ((20'd400 + (counter/32)) * 20'd640) + 20'd608 + (counter % 32);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
		Button_Start_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd64;
			pixel_start_in = 20'd96;
		end
		Button_GameOver_Setup:
		begin
			sprite_height_in = 8'd32;
			sprite_width_in = 8'd64;
			pixel_start_in = 20'd5_216;
		end
		Button_Fetch:
		begin
			pixel_at = counter;
		end
		Button:
		begin
			sram_addr_in = ((20'd64 + (counter>>6)) * 20'd640) + 20'd288 + (counter%64);
			sram_data_in = sprite_data;
			if (sram_data_in != 0)
			begin
				sram_write_en = 1'b1;
				sram_ready = 1'b1;
			end
			counter_in = counter + 1;
		end
	endcase


// Doing this at the end instead of in each individual step resulted in weird glitches
// Potentitally timing related?	
//	case (State)
//	Background, Shooted, Mouse, Shooter_Base, Shooter_Top, Score, Score_Dec, Path_BG:
//	begin
//			sram_data_in = sprite_data;
//			if (sram_data_in != 0)
//			begin
//				sram_write_en = 1'b1;
//				sram_ready = 1'b1;
//			end
//			counter_in = counter + 1;
//	end
//	default: ;
//	endcase
end

spriteROM sprites(.Clk, .read_address(fetched_addr), .data_Out(sprite_data));

logic [19:0] fetched_addr, pixel_at, pixel_start, pixel_start_in, sprite_start;
sprite_fetcher #(19, 8, 8, 160) fetcher(.start_addr(sprite_start), .width(sprite_width), .height(sprite_height), .pixel(pixel_at), .read_addr(fetched_addr));

// "SCORE" word display
logic [2:0] score_letter;
logic [19:0] score_start_addr;
score_word score_addr(.letter(counter >> 6), .start_addr(score_start_addr));

logic use_score_start; // Uses start addr from "SCORE" word display
logic use_score_digit; // Uses start addr from decimal score display
logic use_ball_start; // Uses the ball start addr for balls
logic use_shot_ball_addr; // Uses the ball start addr for the shot ball
always_comb begin
	if (use_score_start) begin
		sprite_start = score_start_addr;
	end
	else if (use_score_digit) begin
		sprite_start = score_digit_addr;
	end
	else if (use_ball_start) begin
		sprite_start = ball_start_addr;
	end
	else if (use_shot_ball_addr) begin
		sprite_start = shot_ball_addr;
	end
	else begin
		sprite_start = pixel_start;
	end
end


// Decimal score display
logic [5:0] score_digit;
logic [19:0] score_digit_addr;
font_addr score_dec_addr(.letter(score_digit), .font_addr(score_digit_addr));

assign score_digit = dec_score[counter >> 6] + 6'd26;

// Ball start_addr fetcher
logic [1:0] draw_ball_color;
logic [19:0] ball_start_addr;
logic [4:0] current_ball;
assign current_ball = counter >> 10;
assign draw_ball_color = Path_Buffer[current_ball]; // TODO: Make sure this works.
ball_color ball_path_colors(.ball_num(draw_ball_color - 1'b1), .start_addr(ball_start_addr));

// Shot ball start_addr fetcher
logic [19:0] shot_ball_addr;
ball_color ball_shot_color(.ball_num(ballColor), .start_addr(shot_ball_addr));

endmodule


module ball_color(
	input [1:0] ball_num,
	output logic [19:0] start_addr
);

always_comb begin
	case (ball_num)
		2'd0: start_addr = 20'd0;
		2'd1: start_addr = 20'd5_120;
		2'd2: start_addr = 20'd10_240;
		2'd3: start_addr = 20'd15_360;
		default: start_addr = 20'd0;
	endcase
end

endmodule
