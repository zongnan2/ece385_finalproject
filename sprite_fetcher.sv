module sprite_fetcher
#(parameter MEM_SIZE = 19, MAX_WIDTH=8, MAX_HEIGHT=8, SHEET_WIDTH=160)
(
	input [MEM_SIZE-1:0] start_addr,
	input [MAX_WIDTH-1:0] width, 
	input [MAX_HEIGHT-1:0] height,
	input [MEM_SIZE-1:0] pixel,
	output [MEM_SIZE-1:0] read_addr
);

assign read_addr = start_addr + ((pixel / width) * SHEET_WIDTH) + (pixel & (width-1'b1));

endmodule
