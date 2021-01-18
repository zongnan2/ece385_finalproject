module sram_controller(
	input Clk, Reset,
	// Set ready to 1 when you want to perform a write or read operation
	// write_en = 1 for write, 0 for read
	input ready, write_en,
	input [19:0] addr,
	input [15:0] data_w,
	inout wire [15:0] sram_data,
	output logic done,
	output logic [19:0] sram_addr,
	output logic [15:0] data,
	output logic sram_oe_n, sram_we_n, sram_ce_n, sram_lb_n, sram_ub_n
);

logic [19:0] addr_local, addr_in;
logic [15:0] data_write_buffer, data_read_buffer, data_read_buffer_in;
logic we_n, we_n_in;
logic oe_n, oe_n_in;
logic tristate, tristate_in;

enum logic [1:0] {
	Wait,
	Read,
	Write
} State, Next_State;


always_ff @ (posedge Clk)
begin
	if (Reset)
	begin
		State <= Wait;
		addr_local <= 0;
		data_read_buffer <= 0;
		data_write_buffer <= 0;
		we_n <= 1;
		oe_n <= 1;
		tristate <= 1;
	end
	else
	begin
		State <= Next_State;
		addr_local <= addr_in;
		data_read_buffer <= data_read_buffer_in;
		data_write_buffer <= data_w;
		we_n <= we_n_in;
		oe_n <= oe_n_in;
		tristate <= tristate_in;
	end
end


// These are active low, so have these values always be active.
assign sram_lb_n = 1'b0;
assign sram_ub_n = 1'b0;
assign sram_ce_n = 1'b0;

assign sram_we_n = we_n;
assign sram_oe_n = oe_n;
assign sram_addr = addr_local;
assign sram_data = (!tristate) ? data_write_buffer : 16'bZ;
assign data = data_read_buffer;

always_comb
begin
	done = 1'b0;
	oe_n_in = 1'b1; // These are active low.
	we_n_in = 1'b1;
	addr_in = addr_local;
	tristate_in = 1'b1;
	data_read_buffer_in = data_read_buffer;

	unique case (State)
		Wait:
		begin
			if (ready)
			begin
				if (write_en)
					Next_State = Wait;
//					Next_State = Write;
				else
					Next_State = Read;
			end
			else
				Next_State = Wait;
		end
		Read:
		begin
			Next_State = Wait;
		end
		default: ;
	endcase

	unique case (State)
		Wait:
		begin
			done = 1'b1;
			oe_n_in = 1'b1;
			
			if (ready)
			begin
				addr_in = addr;
				
				if (write_en)
				begin
					// Writing
					we_n_in = 1'b0;
					tristate_in = 1'b0;
				end
				else
				begin
					// Reading
					oe_n_in = 1'b0;
					data_read_buffer_in = sram_data;
				end
			end
		end
		Read:
		begin
			oe_n_in = 1'b1; // Double check
		end
//		Write:
//		begin
//			tristate_in = 1'b0;
//		end
		default: ;
	endcase
end

endmodule
