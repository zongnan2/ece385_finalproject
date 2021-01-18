/*
 * Returns the x and y dimension unit vectors for a cursor at a specifc x and y location
 * The vectors are based off an origin at the center of the screen pointing toward the cursor's location
 * We map the first quadrant's (x, y) positions into a LUT and then just look up what the corresponding
 * unit vectors should be for that location.
 * 
 * To lower the size of the LUT, we have a resolution of 8 pixels and we store only 8 bits of precision.
 * This means that every 8 pixels on the screen in either the x or y direction we put an entry for that location
 * in the LUT. Then for any arbitrary (X, y) location we just round to the nearest point in the LUT.
 */
module cursor_vector(
	input Clk,
	input [9:0] cursor_x, cursor_y,
	output logic [8:0] x_vector, y_vector
);

logic [10:0] cursor_estimate;
logic [9:0] centered_origin_x, centered_origin_y;
logic [9:0] first_quad_x, first_quad_y;
logic [7:0] fq_x_vector, fq_y_vector;
logic [8:0] x_vector_fixed, y_vector_fixed;
logic half_x, half_y;
logic x_neg, y_neg;

assign centered_origin_x = cursor_x - 10'd320;
assign centered_origin_y = 10'd240 - cursor_y;

assign y_vector = y_neg ? -{1'b0, fq_y_vector} : {1'b0, fq_y_vector};
assign x_vector = x_neg ? -{1'b0, fq_x_vector} : {1'b0, fq_x_vector};

// The positions of the (x, y) if we map it to the first quadrant. Essentially the absolute value
// of x and absolute value of y.
assign first_quad_x = centered_origin_x[9] == 1 ? -centered_origin_x : centered_origin_x;
assign first_quad_y = centered_origin_y[9] == 1 ? -centered_origin_y : centered_origin_y;

// Use this to round to the nearest entry in the lookup table. Instead of always rounding down,
// round to the closest value in the LUT.
assign half_x = ((first_quad_x & 9'b000000111) >= 3'b100) ? 1'b1 : 1'b0;
assign half_y = ((first_quad_y & 9'b000000111) >= 3'b100) ? 1'b1 : 1'b0;

always_comb
begin
	cursor_estimate = ((first_quad_x >> 3) + half_x) * (240>>3) + ((first_quad_y >> 3) + half_y);
end

x_vectors x_vecs(.Clk(Clk), .read_address(cursor_estimate), .data_Out(fq_x_vector));
y_vectors y_vecs(.Clk(Clk), .read_address(cursor_estimate), .data_Out(fq_y_vector));

// It takes one clock cycle to get the vectors, so use position where the cursor was at the original
// lookup time.
always_ff @ (posedge Clk)
begin
	x_neg <= centered_origin_x[9] == 1;
	y_neg <= centered_origin_y[9] == 1;
end

endmodule
