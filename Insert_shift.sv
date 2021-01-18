module Insert_Shift
(
	input [9:0] 			Shooted_pos_X,
	input [3:0]				Color_in,
	input [9:0]	Path[25:0],
	output logic [9:0] Path_in[25:0]

);

	always_comb
	begin
		if (Shooted_pos_X/32 == 1)
			Path_in[25:0] = {Path[25:20],Color_in,Path[19:1]};
			
		else if (Shooted_pos_X/32 == 2)
			Path_in[25:0] = {Path[25:19],Color_in,Path[18:1]};
			
		else if (Shooted_pos_X/32 == 3)
			Path_in[25:0] = {Path[25:18],Color_in,Path[17:1]};
			
		else if (Shooted_pos_X/32 == 4)
			Path_in[25:0] = {Path[25:17],Color_in,Path[16:1]};
			
		else if (Shooted_pos_X/32 == 5)
			Path_in[25:0] = {Path[25:16],Color_in,Path[15:1]};
			
		else if (Shooted_pos_X/32 == 6)
			Path_in[25:0] = {Path[25:15],Color_in,Path[14:1]};
			
		else if (Shooted_pos_X/32 == 7)
			Path_in[25:0] = {Path[25:14],Color_in,Path[13:1]};
			
		else if (Shooted_pos_X/32 == 8)
			Path_in[25:0] = {Path[25:13],Color_in,Path[12:1]};
			
		else if (Shooted_pos_X/32 == 9)
			Path_in[25:0] = {Path[25:12],Color_in,Path[11:1]};
			
		else if (Shooted_pos_X/32 == 10)
			Path_in[25:0] = {Path[25:11],Color_in,Path[10:1]};
			
		else if (Shooted_pos_X/32 == 11)
			Path_in[25:0] = {Path[25:10],Color_in,Path[9:1]};
			
		else if (Shooted_pos_X/32 == 12)
			Path_in[25:0] = {Path[25:9],Color_in,Path[8:1]};
			
		else if (Shooted_pos_X/32 == 13)
			Path_in[25:0] = {Path[25:8],Color_in,Path[7:1]};
			
		else if (Shooted_pos_X/32 == 14)
			Path_in[25:0] = {Path[25:7],Color_in,Path[6:1]};
			
		else if (Shooted_pos_X/32 == 15)
			Path_in[25:0] = {Path[25:6],Color_in,Path[5:1]};
			
		else if (Shooted_pos_X/32 == 16)
			Path_in[25:0] = {Path[25:5],Color_in,Path[4:1]};
			
		else if (Shooted_pos_X/32 == 17)
			Path_in[25:0] = {Path[25:4],Color_in,Path[3:1]};
			
		else if (Shooted_pos_X/32 == 18)
			Path_in[25:0] = {Path[25:3],Color_in,Path[2:1]};
			
		else if (Shooted_pos_X/32 == 19)
			Path_in[25:0] = {Path[25:2],Color_in,Path[1]};
			
		else if (Shooted_pos_X/32 == 20)
			Path_in[25:0] = {Path[25:1],Color_in};
			

	end

endmodule