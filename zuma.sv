module zuma (
	input Clk,
			Reset,
	input leftButton,
	input [9:0] cursorX,
	input [9:0] cursorY,
	input dead, win,
	output [1:0] Curr_State // 0 = Start, 1 = Running, 2 = Game Over
);

enum logic [1:0] {
	Start,
	Running,
	Game_Over
} State, Next_State;

logic mouse_over_button;

assign Curr_State = State;

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Start;
	end
	else
	begin
		State <= Next_State;
	end
end


always_comb
begin
	Next_State = State;
	unique case (State)
		Start:
		begin
			if (mouse_over_button && leftButton)
			begin
				Next_State = Running;
			end
			else
			begin
				Next_State = Start;
			end
		end
		Running:
		begin
			if (dead)
			begin
				Next_State = Game_Over;
			end
			else if (win)
			begin
				Next_State = Start;
			end
			else
			begin
				Next_State = Running;
			end
		end
		Game_Over:
		begin
			if (mouse_over_button && leftButton)
			begin
				Next_State = Running;
			end
			else
			begin
				Next_State = Game_Over;
			end
		end
	endcase
end

always_comb
begin
	mouse_over_button = ((cursorX >= 10'd288 && cursorX <= 10'd352) && (cursorY >= 10'd64 && cursorY <= 10'd96));
end

endmodule
