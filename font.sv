// Returns a font's sprite starting address given a specified letter or number.
module font_addr(
	input [5:0] letter,
	output logic [19:0] font_addr
);

always_comb begin
	unique case (letter)
		// Row 1
		6'd0: font_addr = 20'd10_272;		// A
		6'd1: font_addr = 20'd10_280;		// B
		6'd2: font_addr = 20'd10_288;		// C
		6'd3: font_addr = 20'd10_296;		// D
		6'd4: font_addr = 20'd10_304;		// E
		6'd5: font_addr = 20'd10_312;		// F
		6'd6: font_addr = 20'd10_320;		// G
		6'd7: font_addr = 20'd10_328;		// H
		// Row 2
		6'd8: font_addr = 20'd11_552;		// I
		6'd9: font_addr = 20'd11_560;		// J
		6'd10: font_addr = 20'd11_568;	// K
		6'd11: font_addr = 20'd11_576;	// L
		6'd12: font_addr = 20'd11_584;	// M
		6'd13: font_addr = 20'd11_592;	// N
		6'd14: font_addr = 20'd11_600;	// O
		6'd15: font_addr = 20'd11_608;	// P
		// Row 3
		6'd16: font_addr = 20'd12_832;	// Q
		6'd17: font_addr = 20'd12_840;	// R
		6'd18: font_addr = 20'd12_848;	// S
		6'd19: font_addr = 20'd12_856;	// T
		6'd20: font_addr = 20'd12_864;	// U
		6'd21: font_addr = 20'd12_872;	// V
		6'd22: font_addr = 20'd12_880;	// W
		6'd23: font_addr = 20'd12_888;	// X
		// Row 4
		6'd24: font_addr = 20'd14_112;	// Y
		6'd25: font_addr = 20'd14_120;	// Z
		6'd26: font_addr = 20'd14_128;	// 0
		6'd27: font_addr = 20'd14_136;	// 1
		6'd28: font_addr = 20'd14_144;	// 2
		6'd29: font_addr = 20'd14_152;	// 3
		6'd30: font_addr = 20'd14_160;	// 4
		6'd31: font_addr = 20'd14_168;	// 5
		// Row 5
		6'd32: font_addr = 20'd15_392;	// 6
		6'd33: font_addr = 20'd15_400;	// 7
		6'd34: font_addr = 20'd15_408;	// 8
		6'd35: font_addr = 20'd15_416;	// 9
		default: font_addr = 20'd10_272;
	endcase
end
endmodule

// Returns the letters starting addresses for the word "SCORE"
module score_word(
	input [2:0] letter,
	output [19:0] start_addr
);
logic [5:0] full_letter;

always_comb begin
	case (letter)
		3'd0: full_letter = 6'd18; // S
		3'd1: full_letter = 6'd2;	// C
		3'd2: full_letter = 6'd14;	// O
		3'd3: full_letter = 6'd17;	// R
		3'd4: full_letter = 6'd4;	// E
		default: full_letter = 6'd18;
	endcase
end

font_addr font_retriever(.letter(full_letter), .font_addr(start_addr));

endmodule

