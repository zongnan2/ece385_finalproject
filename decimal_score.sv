module decimal_score(
	input Clk,
	input Reset,
	input [15:0] score,
	output logic [4:0][3:0] dec_score
);

logic [4:0][3:0] computed_score, computed_score_in;
logic [15:0] last_score, last_score_in;
logic [15:0] temp_score, temp_score_in;
logic [2:0] counter, counter_in;

enum logic [1:0] {
	Wait,
	Calculate
} State, Next_State;


assign dec_score = computed_score;

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Wait;
		counter <= 0;
		last_score <= 0;
		computed_score <= 0;
		temp_score <= 0;
	end
	else
	begin
		State <= Next_State;
		counter <= counter_in;
		last_score <= last_score_in;
		computed_score <= computed_score_in;
		temp_score <= temp_score_in;
	end
end

always_comb
begin
	counter_in = counter;
	computed_score_in = computed_score;
	last_score_in = last_score;
	temp_score_in = temp_score;

	unique case (State)
		Wait:
		begin
			if (last_score != score)
				Next_State = Calculate;
			else
				Next_State = Wait;
		end
		Calculate:
		begin
			if (counter >= 3'd5)
				Next_State = Wait;
			else
				Next_State = Calculate;
		end
		default: ;
	endcase
	
	case (State)
		Wait:
		begin
			counter_in = 0;
		end
		Calculate:
		begin
			if (counter == 0)
			begin
				last_score_in = score;
				computed_score_in[0] = (score % 10);
				temp_score_in = (score / 10);
			end
			else
			begin
				computed_score_in[counter] = (temp_score % 10);
				temp_score_in = (temp_score / 10);
			end
			counter_in = counter + 1;
		end
	endcase
end
endmodule
