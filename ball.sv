//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//																								 --
//		Modified for final project to use as Zuma shooter ball.            --
//-------------------------------------------------------------------------


module shot_ball( input     Clk,                // 50 MHz clock
                            Reset,              // Active-high reset signal
                            frame_clk,          // The clock indicating a new frame (~60Hz)
				  input [9:0]	 ClickX, ClickY,
				  input [8:0]	 x_vector, y_vector,
				  input		    leftButton,
              output logic  [9:0] ballX, ballY
              );
    
    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
    
    logic [9:0] Ball_X_Pos_in, Ball_Y_Pos_in;
	 logic [9:0] X_Vector, Y_Vector;
	 logic [15:0] Frame_Count, Frame_Count_in;
	 logic [31:0] X_Position_Temp, Y_Position_Temp;
	 logic [31:0] Extended_X_Vector, Extended_Y_Vector; 
	 
	 logic [9:0] Ball_Y_Pos = Ball_Y_Center;
	 logic [9:0] Ball_X_Pos = Ball_X_Center;
	 
	 assign Extended_X_Vector = {{23{X_Vector[8]}}, X_Vector[8:0]};
	 assign Extended_Y_Vector = {{23{Y_Vector[8]}}, Y_Vector[8:0]};
	 
	 assign ballX = Ball_X_Pos;
	 assign ballY = Ball_Y_Pos;
	 
    
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk)
	 begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
				X_Vector <= x_vector;
				Y_Vector <= y_vector;
				Frame_Count <= 16'b0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
				Frame_Count <= Frame_Count_in;
        end
    end
    
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
		  X_Position_Temp = Ball_X_Pos;
		  Y_Position_Temp = Ball_Y_Pos;
		  Frame_Count_in = Frame_Count;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
				Frame_Count_in = Frame_Count + 1;
				
				// We're multiplying the unit vector by 2^3 in order to make the ball move faster.
				X_Position_Temp = Frame_Count * (Extended_X_Vector << 3);
				Y_Position_Temp = Frame_Count * (Extended_Y_Vector << 3);
        
            // Update the ball's position with its motion
            Ball_X_Pos_in = 320 + (X_Position_Temp >> 8);
            Ball_Y_Pos_in = 240 - (Y_Position_Temp >> 8);
        end
    end
endmodule
