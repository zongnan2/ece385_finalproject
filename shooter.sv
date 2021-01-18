// Shooter Module
module Shooter(
	input logic Clk, Reset,
	input logic frame_clk,
	input logic [1:0] random,
	input logic [9:0] cursorX, cursorY,
	input logic [8:0] x_vector, y_vector,
	input logic leftButton, middleButton, rightButton,
	input logic inserted,
	input logic [1:0] Game_State,
	output logic [9:0] ballX, ballY,
	output logic [1:0] ballColor // starting from 0 (add 1 to get non-zero color)
);

logic [9:0] ballX_Raw, ballY_Raw, ballX_in, ballY_in;
logic [1:0] ballColor_local, ballColor_local_in, ballColor_in;
logic ball_reset;
shot_ball ball_instance(.Clk,
								.Reset(Reset | ball_reset),
								.frame_clk,
								.ballX(ballX_Raw),
								.ballY(ballY_Raw),
								.x_vector,
								.y_vector,
								.leftButton);
								
enum logic [1:0] {
	Wait,
	Moving,
	Reload
} State, Next_State;


always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Wait;
		ballColor_local = random;
	end
	else
	begin
		State <= Next_State;
		ballColor_local <= ballColor_local_in;
	end
end

always_comb
begin
	ball_reset = 0;
	ballColor_local_in = ballColor_local;
	
	unique case (State)
	Wait:
	begin
		if (Game_State == 2'b0 || Game_State == 2'd2)
		begin
			Next_State = Wait;
		end
		else if (leftButton_rising_edge)
		begin
			Next_State = Moving;
		end
		else if (rightButton_rising_edge)
		begin
			Next_State = Reload;
		end
		else
			Next_State = Wait;
	end
	Moving:
	begin
		if (ballX_Raw >= 10'd640 || ballY_Raw >= 10'd480 || inserted)
			Next_State = Reload;
		else
			Next_State = Moving;
	end
	Reload:
		Next_State = Wait;
	endcase
	
	case (State)
	Wait:
	begin
		ball_reset = 1'b1;
	end
	Reload:
	begin
		ballColor_local_in = random;
	end
	endcase
end

always_ff @(posedge Clk)
begin
	if (Reset)
	begin
		ballColor <= 0;
		ballX <= ballX_Raw;
		ballY <= ballY_Raw;
	end
	else
	begin
		ballColor <= ballColor_in;
		ballX <= ballX_in;
		ballY <= ballY_in;
	end
		
end

always_comb begin
	ballColor_in = ballColor;
	ballX_in = ballX;
	ballY_in = ballY;
	if (frame_clk_rising_edge)
	begin
		ballColor_in = ballColor_local;
		ballY_in = ballY_Raw;
		ballX_in = ballX_Raw;
	end
end

// Detect rising edge of frame_clk
logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk)
begin
	frame_clk_delayed <= frame_clk;
	frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end

// Detect rising edge of left mouse button
logic leftButton_delayed, leftButton_rising_edge;
always_ff @ (posedge Clk)
begin
  leftButton_delayed <= leftButton;
  leftButton_rising_edge <= (leftButton == 1'b1) && (leftButton_delayed == 1'b0);
end

// Detect rising edge of right mouse button
logic rightButton_delayed, rightButton_rising_edge;
always_ff @ (posedge Clk)
begin
  rightButton_delayed <= rightButton;
  rightButton_rising_edge <= (rightButton == 1'b1) && (rightButton_delayed == 1'b0);
end
	

endmodule
