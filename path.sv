module path( 	input 		Clk,						//50 MHz clock
									frame_clk,				//new frame clock
									Reset,					//Active high reset signal
					input [3:0] Color_in,				
					input [1:0] random_color,
					input [9:0] Shooted_pos_X,			//Shooting ball's x position
									Shooted_pos_Y,			//Shooting ball's y position
					input [1:0] Game_State,
					output logic [9:0] Path_X[25:0],
											 Path_Y[25:0],
					output logic [3:0] Path_Idx[25:0],
					output logic [15:0] score,
					output logic dead,
					output logic win,
					output logic inserted
				);


//	parameter bit [3:0] Path_Start[25:0] = '{3'd1, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
//	parameter bit [9:0] Path_Pos[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, -10'd0, 10'd32, 10'd64, 10'd96, 10'd128, 10'd160, 10'd192, 10'd224, 10'd256, 10'd288, 10'd320, 10'd352, 10'd384, 10'd416, 10'd448, 10'd480, 10'd512, 10'd544, 10'd576, 10'd608};
//	parameter bit [9:0] Path_X_Start[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768};
	parameter logic [3:0] Path_Start[25:0] = '{3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
//	parameter logic [9:0] Path_Pos[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd0, 10'd32, 10'd64, 10'd96, 10'd128, 10'd160, 10'd192, 10'd224, 10'd256, 10'd288, 10'd320, 10'd352, 10'd384, 10'd416, 10'd448, 10'd480, 10'd512, 10'd544, 10'd576, 10'd608};
//	parameter logic [9:0] Path_X_Start[25:0] = '{10'd0, 10'd768, 10'd64, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768};
	parameter logic [9:0] Path_X_Start[25:0] = '{10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768, 10'd768};
	parameter logic [9:0] Path_Pos[25:0] = '{10'd0, 10'd32, 10'd64, 10'd96, 10'd128, 10'd160, 10'd192, 10'd224, 10'd256, 10'd288, 10'd320, 10'd352, 10'd384, 10'd416, 10'd448, 10'd480, 10'd512, 10'd544, 10'd576, 10'd608, 10'd640, 10'd672, 10'd704, 10'd736, 10'd768, 10'd800};
	parameter logic [9:0] Path_Y_Start[25:0] = '{26{10'd400}};

	logic [9:0] Path_X_Pos [25:0] = Path_X_Start;
	logic [9:0] Path_Y_Pos [25:0] = Path_Y_Start;
	logic [3:0] Path [25:0] = Path_Start;
	assign Path_X[25:0] = Path_X_Pos[25:0];
	assign Path_Y[25:0] = Path_Y_Pos[25:0];
	assign Path_Idx[25:0] = Path[25:0];
	
	logic [9:0] Path_X_Pos_in[25:0], Path_Y_Pos_in[25:0];
	logic	[9:0] Path_X_Motion[25:0], Path_Y_Motion[25:0], Path_X_Motion_in[25:0], Path_Y_Motion_in[25:0];
	logic [3:0] Path_in[25:0], Path_temp[25:0], Path_temp_in[25:0];
	logic [9:0] Path_cancel[25:0], Path_cancel_in[25:0];
	
	logic [15:0] score_in;
	
	logic halfer, halfer_in, can_insert, can_insert_in, is_collision;
	logic dead_in, win_in;
	
	logic Copy, Copy_in; // Determines whether we copy values for the rest of the insertion.
	
	logic [9:0] calculated_index, calculated_index_in;
	logic [9:0] ball_count = 10'd30;
	logic [9:0] ball_count_in;
	
	logic [5:0] Counter, Counter_in, Cancel_Count, Cancel_Count_in, Cancel_Index, Cancel_Index_in;
	logic [3:0] inserted_color, inserted_color_in;
	enum logic [4:0] {
		Halt,
		Clean,
		Wait,
		Add_Random,
		Move,
		Move_Counter,
		Update_Pos_Prep_Idx,
		Update_Pos,
		Insert_Check_Prep_Idx,
		Insert_Check,
		Insert_Prep_Idx,
		Insert,
		Insert_Counter,
		Insert_Copy,
		Cancel_Calculate, //
		Cancel_Calculate_Counter, //
		Cancel, //
		Cancel_Counter, //
		Add_Score,
		Check_Dead,
		Check_Win
	} State, next_State;
	
//	assign shooted_index = 10'd25 - (Shooted_pos_X >> 5);
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			State <= Halt;
			Path_X_Pos[25:0] <= Path_X_Start[25:0];
			Path_Y_Pos[25:0] <= Path_Y_Start[25:0];
			Path_X_Motion[25:0] <= '{26{10'd0}};
			Path_Y_Motion[25:0] <= '{26{10'd0}};
			Path[25:0] <= Path_Start[25:0];
			Path_cancel[25:0] <= '{26{10'd0}};
			Counter <= 10'd25;
			Path_temp <= '{26{10'd0}};
			dead <= 0;
			Copy <= 0;		
			Cancel_Index <= 0;
			Cancel_Count <= 0;
			inserted_color <= 0;
			score <= 0;
			can_insert <= 0;
			calculated_index <= 0;
			ball_count <= 10'd30;
			win <= 0;
		end
		else
		begin
			State <= next_State;
			Path_X_Pos[25:0] <= Path_X_Pos_in[25:0];
			Path_Y_Pos[25:0] <= Path_Y_Pos_in[25:0];
			Path_X_Motion[25:0] <= Path_X_Motion_in[25:0];
			Path_Y_Motion[25:0] <= Path_Y_Motion_in[25:0];
			Path[25:0] <= Path_in[25:0];
			Path_cancel[25:0] <= Path_cancel_in[25:0];
			Counter <= Counter_in;
			Path_temp[25:0] <= Path_temp_in[25:0];
			dead <= dead_in;
			Copy <= Copy_in;
			Cancel_Index <= Cancel_Index_in;
			Cancel_Count <= Cancel_Count_in;
			inserted_color <= inserted_color_in;
			score <= score_in;
			can_insert <= can_insert_in;
			calculated_index <= calculated_index_in;
			ball_count <= ball_count_in;
			win <= win_in;
		end
	end
	
	always_comb
	begin
		next_State = State;
		Path_X_Pos_in[25:0] = Path_X_Pos[25:0];
		Path_Y_Pos_in[25:0] = Path_Y_Pos[25:0];
		Path_X_Motion_in[25:0] = Path_X_Motion[25:0];
		Path_Y_Motion_in[25:0] = Path_Y_Motion[25:0];
		Path_in[25:0] = Path[25:0];
		Path_cancel_in[25:0] = Path_cancel[25:0];
		Counter_in = Counter;
		Path_temp_in = Path_temp;
		dead_in = dead;
		win_in = win;
		Copy_in = Copy;
		inserted = 0;
		Cancel_Index_in = Cancel_Index;
		Cancel_Count_in = Cancel_Count;
		inserted_color_in = inserted_color;
		score_in = score;
		can_insert_in = can_insert;
		calculated_index_in = calculated_index;
		ball_count_in = ball_count;
		
		unique case(State)
			Halt:
			begin
				if (Game_State == 1'd1)
					next_State = Clean;
				else
					next_State = Halt;
			end
			Clean:
			begin
				next_State = Wait;
			end
			Move:
			begin
				if (Counter == 6'd0)
				begin
					next_State = Update_Pos_Prep_Idx;
				end
				else
					next_State = Move_Counter;
			end
			Move_Counter:
			begin
				next_State = Move;
			end
			Insert_Check:
			begin
				if (can_insert == 1'b1)
				begin
					next_State = Insert_Prep_Idx;
				end
				else if (Counter <= 6'd5)
				begin
					next_State = Wait;
				end
				else
				begin
					next_State = Insert_Check;
				end
			end
			Insert:
			begin
				if (Counter == 6'd0)
				begin
					next_State = Insert_Copy;
				end
				else
					next_State = Insert_Counter;
			end
			Insert_Counter:
			begin
				next_State = Insert;
			end
			Insert_Copy:
			begin
				Counter_in = 6'd25;
				next_State = Cancel_Calculate;
			end
			Add_Score:
				next_State = Check_Dead;
			Wait:
			begin
			   if (dead || win)
				begin
					next_State = Halt;
				end
				else if (frame_clk && halfer)
				begin
					if (ball_count == 0)
						next_State = Move;
					else
						next_State = Add_Random;
				end
				else if (frame_clk)
					next_State = Check_Dead;
				else
					next_State = Wait;
			end
			Update_Pos:
			begin
				if (Counter >= 6'd25)
				begin
					next_State = Check_Dead;
				end
				else
					next_State = Update_Pos;
			end
			Cancel_Calculate:
			begin
				if (Counter <= 6'd3)
				begin
					if (Cancel_Count >= 6'd3)
					begin
						Counter_in = 6'd25;
						next_State = Cancel;
					end
					else
					begin
						next_State = Wait;
					end
				end
				else
				begin
					next_State = Cancel_Calculate_Counter;
				end
			end
			Cancel_Calculate_Counter:
			begin
				next_State = Cancel_Calculate;
			end
			Cancel:
			begin
				if (Counter == 0)
					next_State = Add_Score;
				else
					next_State = Cancel_Counter;
			end
			Cancel_Counter:
			begin
				next_State = Cancel;
			end
			Update_Pos_Prep_Idx:
			begin
				next_State = Update_Pos;
			end
			Check_Dead:
			begin
				next_State = Check_Win;
			end
			Check_Win:
			begin
				next_State = Insert_Check_Prep_Idx;
			end
			Insert_Check_Prep_Idx:
			begin
				next_State = Insert_Check;
			end
			Insert_Prep_Idx:
				next_State = Insert;
			Add_Random:
			begin
				next_State = Move;
			end
			default: ;
		endcase
		
		case(State)
			Clean:
			begin
				Path_X_Pos_in[25:0] = '{26{10'd768}};
				Path_Y_Pos_in[25:0] = '{26{10'd400}};
				Path_X_Motion_in[25:0] = '{26{10'd0}};
				Path_Y_Motion_in[25:0] = '{26{10'd0}};
				Path_in[25:0] = '{26{3'd0}};;
				Path_cancel_in[25:0] = '{26{10'd0}};;
				Counter_in = 6'd25;
				Path_temp_in = '{26{10'd0}};
				dead_in = 0;
				win_in = 0;
				Copy_in = 0;
				inserted = 0;
				Cancel_Index_in = 0;
				Cancel_Count_in = 0;
				inserted_color_in = 0;
				score_in = 0;
				can_insert_in = 0;
				calculated_index_in = 0;
				ball_count_in = 10'd30;
			end
			Wait:
			begin
				Counter_in = 6'd25;
				Path_temp_in = '{26{10'd0}};
				Copy_in = 0;
				Path_cancel_in = '{26{10'd0}};
				Cancel_Count_in = 0;
				Cancel_Index_in = 0;
				inserted_color_in = 0;
				can_insert_in = 0;
			end
			Move:
			begin
				for (int i = 25; i > 0; i--) begin // Won't work for index 0
					if (Counter == i && Path[i] > 0 && ((Path_X_Pos[i-1]-Path_X_Pos[i]) > 10'd32 || Path[i-1] == 0))
					begin
						for (int k = 25; k >= i; k--) begin
							Path_X_Motion_in[k] = 10'b1;
							Path_Y_Motion_in[k] = 10'b0;
						end
						for (int k = i-1; k >= 0; k--) begin
							Path_X_Motion_in[k] = 10'b0;
							Path_Y_Motion_in[k] = 10'b0;
						end
						for (int j = 1; j < 26; j++) begin
							Path_X_Pos_in[j] = Path_X_Pos[j] + Path_X_Motion_in[j]; //TODO: Check if we should use Motion instead of Motion_in
							Path_Y_Pos_in[j] = Path_Y_Pos[j] + Path_Y_Motion_in[j];
						end
						Counter_in = 0;
					end
				end
			end
			Move_Counter:
			begin
				if (Counter > 0)
				begin
					Counter_in = Counter - 1;
				end
			end
			
			Update_Pos:
			begin
				if ((Path[Counter] > 0) && (Path_X_Pos[Counter] >= Path_Pos[Counter-1]))
				begin
					Path_in[Counter-1] = Path[Counter];
					Path_in[Counter] = 10'b0;
					
					Path_X_Pos_in[Counter-1] = Path_X_Pos[Counter];
					Path_X_Pos_in[Counter] = 10'd768;
					
					Path_Y_Pos_in[Counter-1] = Path_Y_Pos[Counter];
					Path_Y_Pos_in[Counter] = 10'd400;
				end
				Counter_in = Counter + 1'b1;
			end
			
			Insert: 
			begin
				inserted = 1'b1;
				if (Path[Counter] == 0 && Counter <= calculated_index)
				begin
					Copy_in = 1'b1;
					if (!Copy)
					begin
						Path_X_Pos_in[Counter] = Path_X_Pos[Counter+1'b1] + 10'd32;
					end
				end
				
				if (Copy || Counter > calculated_index)
				begin
					Path_temp_in[Counter] = Path[Counter];
				end
				else if (Counter == calculated_index)
				begin
					Path_temp_in[Counter] = Color_in;
					inserted_color_in = Color_in;
					Cancel_Index_in = Counter;
				end
				else
				begin
					Path_temp_in[Counter] = Path[Counter+1'b1];
				end
			end
			Insert_Copy:
			begin
				for (int i = 0; i < 26; i++) begin
					Path_in[i] = Path_temp[i];
				end;
 			end
			Insert_Counter, Cancel_Counter:
			begin
				if (Counter > 0)
				begin
					Counter_in = Counter - 1'b1;
				end
			end
			Cancel_Calculate_Counter:
			begin
				if (Counter < Cancel_Index && Path[Counter] != inserted_color)
				begin
					Counter_in = 0;
				end
				else if (Counter > 0)
				begin
					Counter_in = Counter - 1'b1;
				end
			end
			Cancel_Calculate:
			begin
				if (Path[Counter] == inserted_color)
				begin
					Path_cancel_in[Counter] = 1'b1;
					Cancel_Count_in = Cancel_Count + 1;
				end
				else
				begin
					if (Counter >= Cancel_Index)
					begin
						Path_cancel_in = '{26{10'd0}};
						Cancel_Count_in = 0;
					end
				end
			end
			Cancel:
			begin
				if (Path_cancel[Counter] == 1'b1)
				begin
					Path_in[Counter] = 3'd0;
				end
			end
			Add_Score:
			begin
				score_in = score + (Cancel_Count * 16'd10);
			end
			Check_Dead:
			begin
				if (Path[0] > 0 | Path[1] > 0 | Path[2] > 0 | Path[3] > 0 | Path[4] > 0 | Path[5] > 0 | Path[6] > 0)
				begin
					dead_in = 1'b1;
				end
			end
			Check_Win:
			begin
				if (ball_count == 0 && ((Path[0]|Path[1]|Path[2]|Path[3]|Path[4]|Path[5]|Path[6]|Path[7]|Path[8]|Path[9]|Path[10]|Path[11]|Path[12]|Path[13]|
					  Path[14]|Path[15]|Path[16]|Path[17]|Path[18]|Path[19]|Path[20]|Path[21]|Path[22]|Path[23]|Path[24]|Path[25]) == 0))
				begin
					win_in = 1'b1;
				end
			end
			Update_Pos_Prep_Idx:
			begin
				Counter_in = 1;
			end
			Insert_Check_Prep_Idx, Insert_Prep_Idx:
			begin
				Counter_in = 6'd25;
			end
			Insert_Check:
			begin
				if (Path[Counter] > 0 && is_collision == 1'b1)
				begin
					can_insert_in = 1'b1;
					if (Shooted_pos_X < Path_X_Pos[Counter] + 10'd16)
						calculated_index_in = Counter;
					else
						calculated_index_in = Counter - 1;
				end
				Counter_in = Counter - 1;
			end
			Add_Random:
			begin
				if (Path[6'd25] == 0)
				begin
					Path_in[6'd25] = random_color + 1;
					Path_X_Pos_in[6'd25] = 0;
					ball_count_in = ball_count - 1;
				end
			end
		endcase
	end
	
always_ff @ (posedge Clk)
begin
	if (Reset)
		halfer <= 0;
	else
		halfer <= halfer_in;
end

always_comb
begin
	halfer_in = halfer;
	if (frame_clk)
	begin
		halfer_in = ~halfer;
		
	end
end

//always_comb
//begin
//	if ((Shooted_pos_X < Path_X_Pos[shooted_index]) && (Path[shooted_index+1'b1] > 0))
//	begin
//		calculated_index = shooted_index + 1'b1;
//	end
//	else if (Shooted_pos_X >= (Path_X_Pos[shooted_index] + 10'd20) &&
//			  (Path_X_Pos[shooted_index] + 10'd32))
//	begin
//		calculated_index = shooted_index - 1'b1;
//	end
//	else
//	begin
//		calculated_index = shooted_index;
//	end
//end

int DistX, DistY, Size;
assign DistX = Shooted_pos_X - (Path_X_Pos[Counter] + 16);
assign DistY = Shooted_pos_Y - (Path_Y_Pos[Counter] + 16);
assign Size = 32;
always_comb begin
  if ( ( DistX*DistX + DistY*DistY) <= (Size*Size) ) 
		is_collision = 1'b1;
  else
		is_collision = 1'b0;
end

endmodule	
