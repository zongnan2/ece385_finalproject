/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */
module spriteROM
(
		input [18:0] read_address,
		input Clk,
		output logic [4:0] data_Out
);

logic [4:0] mem [0:25599];

initial
begin
	 $readmemh("sprites/SpriteSheet.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

// This returns the y dimension unit vectors for a cursor at a specific location
module y_vectors
(
		input Clk,
		input [18:0] read_address,
		output logic [7:0] data_Out
);

logic [7:0] mem [0:1199];

initial
begin
	 $readmemh("LUTs/y_vectors.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule

// This returns the x dimension unit vectors for a cursor at a specific location
module x_vectors
(
		input Clk,
		input [18:0] read_address,
		output logic [7:0] data_Out
);

logic [7:0] mem [0:1199];

initial
begin
	 $readmemh("LUTs/x_vectors.txt", mem);
end


always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule