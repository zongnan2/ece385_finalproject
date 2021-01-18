/*
 * A helper file that has been slightly modified from
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 */

module  frame_buffer
(
		input [4:0] data_in,
		input [18:0] write_address, read_address,
		input we, Clk,

		output logic [4:0] data_out
);

logic [4:0] mem [0:307200];


always_ff @ (posedge Clk) begin
	if (we)
		mem[write_address] <= data_in;
	data_out<= mem[read_address];
end

endmodule
