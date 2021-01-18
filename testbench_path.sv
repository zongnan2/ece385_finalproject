module testbench_path();

timeunit 10ns;
timeprecision 1ns;

logic Clk;
logic frame_clk;
logic Reset;
logic [3:0] Color_in;				
logic [9:0] Shooted_pos_X;
logic [9:0] Shooted_pos_Y;
logic [9:0] Path_X[25:0];
logic [9:0] Path_Y[25:0];
logic [3:0] Path_Idx[25:0];
logic [9:0] Path_cancel[25:0];
logic [5:0] Counter;
logic dead, win;
logic inserted;
logic [15:0] score;
logic [5:0] Cancel_Count, Cancel_Index;
logic [3:0] State;
logic [9:0] calculated_index;
logic is_collision, can_insert;
logic [1:0] random_color;
logic [1:0] Game_State;


path path_inst(.*);

always_comb begin: INTERNAL_MONITORING
	Path_cancel[25:0] = path_inst.Path_cancel[25:0];
	Counter = path_inst.Counter;
	State = path_inst.State;
	Cancel_Count = path_inst.Cancel_Count;
	Cancel_Index = path_inst.Cancel_Index;
	calculated_index = path_inst.calculated_index;
	is_collision = path_inst.is_collision;
	can_insert = path_inst.can_insert;
end

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

initial begin : CLOCK_INITIALIZATION
	Clk = 0;
end

initial begin : TEST
	Reset = 0;
	#2 Reset = 1;
	#2 Reset = 0;
	#2 Shooted_pos_X = 10'd281;
	#2 Shooted_pos_Y = 10'd400;
	#2 Color_in = 4'd2; 
	repeat (5000) begin
		#2 frame_clk = 1;
		#2 frame_clk = 0;
		#225;
		#2 Shooted_pos_X = 10'd50;
		#2 Shooted_pos_Y = 10'd50;
	end
end

endmodule
