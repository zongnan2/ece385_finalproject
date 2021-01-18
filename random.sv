// An 8 bit LSFR modified from Wikipedia and StackOverflow.
module random_2(
	input Clk,
	input Reset,
	output [1:0] value
);

logic [15:0] bits;
logic feedback_poly;
assign feedback_poly = ~(bits[15] ^ bits[14]);

assign value = bits[3:2];

always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		bits <= 16'h367B;
	end
	else
	begin
		bits <= {bits[14:0], feedback_poly};
	end
end


endmodule
