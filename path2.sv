module path( 	input 		Clk,						//50 MHz clock
									frame_clk,				//new frame clock
									Reset,					//Active high reset signal
					input [3:0] Color_in,				
					input [9:0] Shooted_pos_X,			//Shooting ball's x position
									Shooted_pos_Y,			//Shooting ball's y position
					output logic [9:0] Path_X[25:0],
											 Path_Y[25:0],
											 Path_Idx[25:0]
	
				);


//	parameter bit [3:0] Path_Start[25:0] = '{3'd1, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
//	parameter bit [9:0] Path_Pos[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, -10'd0, 10'd32, 10'd64, 10'd96, 10'd128, 10'd160, 10'd192, 10'd224, 10'd256, 10'd288, 10'd320, 10'd352, 10'd384, 10'd416, 10'd448, 10'd480, 10'd512, 10'd544, 10'd576, 10'd608};
//	parameter bit [9:0] Path_X_Start[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000};
	parameter bit [3:0] Path_Start[25:0] = '{3'd1, 3'd1, 3'd1, 3'd2, 3'd2, 3'd2, 3'd2, 3'd0, 3'd3, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0, 3'd0};
	parameter bit [9:0] Path_Pos[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd0, 10'd32, 10'd64, 10'd96, 10'd128, 10'd160, 10'd192, 10'd224, 10'd256, 10'd288, 10'd320, 10'd352, 10'd384, 10'd416, 10'd448, 10'd480, 10'd512, 10'd544, 10'd576, 10'd608};
	parameter bit [9:0] Path_X_Start[25:0] = '{-10'd192, -10'd160, -10'd128, -10'd96, -10'd64, -10'd32, 10'd0, 10'd1000, 10'd64, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000};
//	parameter bit [9:0] Path_X_Start[25:0] = '{10'd1, 10'd2, 10'd3, 10'd4, 10'd5, 10'd6, 10'd7, 10'd32, 10'd64, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000, 10'd1000};
	parameter bit [9:0] Path_Y_Start[25:0] = '{26{10'd400}};
	
	logic [9:0] Path_X_Pos [25:0] = Path_X_Start;
	logic [9:0] Path_Y_Pos [25:0] = Path_Y_Start;
	logic [9:0] Path [25:0] = Path_Start;
	assign Path_X = Path_X_Pos;
	assign Path_Y = Path_Y_Pos;
	assign Path_Idx = Path_Start;
	
	logic [9:0] Path_X_Pos_in[25:0], Path_Y_Pos_in[25:0];
	logic	[9:0] Path_X_Motion[25:0], Path_Y_Motion[25:0], Path_X_Motion_in[25:0], Path_Y_Motion_in[25:0];
	logic [9:0] Path_in[25:0], Path_temp[25:0], Path_temp_in[25:0];
	logic [9:0] Path_cancel[25:0], Path_cancel_in[25:0];
	
	logic [5:0] Counter, Counter_in;
	enum logic [2:0] {
		Wait,
		Move,
		Update_Pos,
		Insert,
		Insert_Copy,
		Cancel
	} State, next_State;
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			State <= Wait;
			Path_X_Pos[25:0] <= Path_X_Start[25:0];
			Path_Y_Pos[25:0] <= Path_Y_Start[25:0];
			Path_X_Motion[25:0] <= '{26{10'd0}};
			Path_Y_Motion[25:0] <= '{26{10'd0}};
			Path[25:0] <= Path_Start[25:0];
			Path_cancel[25:0] <= '{26{10'd0}};
			Counter <= 10'd25;
			Path_temp <= '{26{10'd0}};
			
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
		end
	end
	
	always_comb
	begin
		Path_X_Pos_in[25:0] = Path_X_Pos[25:0];
		Path_Y_Pos_in[25:0] = Path_Y_Pos[25:0];
		Path_X_Motion_in[25:0] = Path_X_Motion[25:0];
		Path_Y_Motion_in[25:0] = Path_Y_Motion[25:0];
		Path_in[25:0] = Path[25:0];
		Path_cancel_in[25:0] = Path_cancel[25:0];
		Counter_in = Counter;
		Path_temp_in = Path_temp;
			

		unique case(State)
			Move:
			begin
				if (Counter == 6'd0)
				begin
					next_State = Update_Pos;
					Counter_in = 1;
				end
				else
					next_State = Move;
			end
			Insert:
				if (Counter == 6'd0)
				begin
					next_State = Insert_Copy;
				end
				else
					next_State = Insert;
			Insert_Copy:
				next_State = Cancel;
			Cancel:
				next_State = Wait;
			Wait:
			begin
				if (frame_clk)
					next_State = Move;
				else
					next_State = Wait;
			end
			Update_Pos:
				if (Counter >= 6'd25)
				begin
					next_State = Wait;
					Counter_in = 25;
				end
				else
					next_State = Update_Pos;
			default: ;
		endcase
		
		case(State)
			Wait:
			begin
				Counter_in = 6'd25;
				Path_temp_in = '{26{10'd0}};
			end
			Move:
			begin
				for (int i = 25; i > 0; i--) begin // Won't work for index 0
					if (Counter == i && (Path_X_Pos[i-1]-Path_X_Pos[i]) > 10'd32)
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
				Counter_in = Counter - 1;
			end
			
			Update_Pos:
			begin
				if ((Path[Counter] > 0) && (Path_X_Pos[Counter] >= Path_Pos[Counter-1]))
				begin
					Path_in[Counter-1] = Path[Counter];
					Path_in[Counter] = 10'b0;
					
					Path_X_Pos_in[Counter-1] = Path_X_Pos[Counter];
					Path_X_Pos_in[Counter] = 10'd1000;
					
					Path_Y_Pos_in[Counter-1] = Path_Y_Pos[Counter];
					Path_Y_Pos_in[Counter] = 10'd400;
				end
				Counter_in = Counter + 1;
			end
			
			Insert:
			begin
				if ((Shooted_pos_Y >= Path_Y_Pos[25]) && (Shooted_pos_Y <= Path_Y_Pos[25] + 32)) 
				begin
					if(Path[shooted_index] != 3'd0)
					begin
						if (Counter > shooted_index)
						begin
							Path_temp_in[Counter] = Path[Counter];
						end
						else if (Counter == shooted_index)
						begin
							Path_temp_in[Counter] = Color_in;
						end
						else if (Counter < shooted_index)
						begin
							Path_temp_in[Counter-1] = Path[Counter];
						end
					end						
				end
				Counter_in = Counter - 1;
			end
			Insert_Copy:
			begin
				for (int i = 0; i < 26; i++) begin
					Path_in[i] = Path_temp[i];
				end
			end
			
			
			Cancel:;
			//begin
			//	for(int i=25; i>0; i--)
			//	begin
			//		if(i > (Shooted_pos_X/32))
			//		begin 
			//			
			//		end
			//	end
			//end
			//begin
			//		if(Path_cancel[25:0]!=26{10'd0})
			//			begin
			//				
			//		
			//		
			//			end
			//		end
			//end
			Wait: ;
		endcase
	
	

//				if (Path_X_Motion[0] + 10'd32 >= 10'd639)
//					begin
//						Path_X_Motion_in[5:0] = 6{10'd0};
//						Path_Y_Motion_in[5:0] = 6{10'd0};
//					end
//				end
//			end
//			
//			Path_X_Pos_in[5:0] = Path_X_Pos[5:0] + Path_X_Motion[5:0];
//			Path_Y_Pos_in[5:0] = Path_Y_Pos[5:0] + Path_Y_Motion[5:0];
//			
//		end
	end
	
logic [9:0] shooted_index;
assign shooted_index = Shooted_pos_X >> 5;
	
	//Insert_shift shift (.Shooted_pos_X, .Color_in, .Path, .Path_in);
	
endmodule
		
//
//			//Default control signal value
//			Gap = 1'b0;
//			int index = 0;
//			
//			
//			unique case (state)
//							
//							Halted:
//									if(Run) next_state = S_0;
//							S_0:  
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_1;
//							S_1:
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_2;
//							S_2:
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_3;
//							S_3:
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_4;
//							S_4:
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_5;
//							S_5:
//									if(Gap)
//										next_state = Move;
//									else
//										next_state = S_6;
//							S_6:
//									next_state = Move; // TODO
//							Move:
//									next_state = S_0;
//
//									
//							
//							
//							
//		   endcase
//			
//			case(state)
//			
//				Halted: ;
//				
//				S_0:
//					begin
//						if(x_pos[1]-x_pos[0] > 10'd32)
//							Gap = 1'b1;
//							index = 0;
//						else
//							Gap = 1'b0;
//					end
//
//				S_1:
//					begin
//						if(x_pos[2]-x_pos[1] > 10'd32)
//							Gap = 1'b1;
//							index = 1;
//						else
//							Gap = 1'b0;
//					end
//				S_2:
//					begin
//						if(x_pos[3]-x_pos[2] > 10'd32)
//							Gap = 1'b1;
//							index = 2;
//						else
//							Gap = 1'b0;
//					end
//				S_3:
//					begin
//						if(x_pos[4]-x_pos[3] > 10'd32)
//							Gap = 1'b1;
//							index = 3;
//						else
//							Gap = 1'b0;
//					end
//				S_4:
//					begin
//						if(x_pos[5]-x_pos[4] > 10'd32)
//							Gap = 1'b1;
//							index = 4;
//						else
//							Gap = 1'b0;
//				S_5:
//					begin
//						if(x_pos[6]-x_pos[5] > 10'd32)
//							Gap = 1'b1;
//							index = 5;
//						else
//							Gap = 1'b0;
//					end
//				S_6:
//					begin
//						if(x_pos[7]-x_pos[6] > 10'd32)
//							Gap = 1'b1;
//							index = 6;
//						else
//							Gap = 1'b0;
//				Move:
//					begin
//						for(int i=index; i>=0; i--){
//							x_pos[i] = x_pos[i] + 10'd1;
//						}
//					end
//					
//						
//				
//	end