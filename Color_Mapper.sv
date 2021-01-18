// color_mapper: Decide which color to be output to VGA for each pixel.
// Dylan Bentfield wrote a python script to generate the following case
// statement based on the colors of the pallete used for generating the sprite sheet.
module  color_mapper ( input [4:0] palette,
                       output logic [7:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
   logic [7:0] Red, Green, Blue;

    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

/* 
 * Generated through a python script I created
 * Don't modify this manually
 */
always_comb
begin
    case(palette)
        5'd0:
        begin
            Red = 8'hff;
            Green = 8'h00;
            Blue = 8'hed;
        end
        5'd1:
        begin
            Red = 8'h00;
            Green = 8'h00;
            Blue = 8'h00;
        end
        5'd2:
        begin
            Red = 8'h0e;
            Green = 8'h04;
            Blue = 8'h21;
        end
        5'd3:
        begin
            Red = 8'h24;
            Green = 8'h14;
            Blue = 8'h2c;
        end
        5'd4:
        begin
            Red = 8'h39;
            Green = 8'h29;
            Blue = 8'h46;
        end
        5'd5:
        begin
            Red = 8'h92;
            Green = 8'h8f;
            Blue = 8'hb8;
        end
        5'd6:
        begin
            Red = 8'hff;
            Green = 8'h97;
            Blue = 8'h57;
        end
        5'd7:
        begin
            Red = 8'hc7;
            Green = 8'hd4;
            Blue = 8'he1;
        end
        5'd8:
        begin
            Red = 8'h8f;
            Green = 8'h57;
            Blue = 8'h65;
        end
        5'd9:
        begin
            Red = 8'h2c;
            Green = 8'h64;
            Blue = 8'h5e;
        end
        5'd10:
        begin
            Red = 8'h42;
            Green = 8'h90;
            Blue = 8'h58;
        end
        5'd11:
        begin
            Red = 8'h05;
            Green = 8'h21;
            Blue = 8'h37;
        end
        5'd12:
        begin
            Red = 8'hf8;
            Green = 8'hff;
            Blue = 8'hb8;
        end
        5'd13:
        begin
            Red = 8'h22;
            Green = 8'h00;
            Blue = 8'h29;
        end
        5'd14:
        begin
            Red = 8'hd6;
            Green = 8'h1a;
            Blue = 8'h88;
        end
        5'd15:
        begin
            Red = 8'hff;
            Green = 8'h41;
            Blue = 8'h7d;
        end
        5'd16:
        begin
            Red = 8'hfa;
            Green = 8'hff;
            Blue = 8'hff;
        end
        5'd17:
        begin
            Red = 8'h42;
            Green = 8'h00;
            Blue = 8'h4e;
        end
        5'd18:
        begin
            Red = 8'hff;
            Green = 8'hcf;
            Blue = 8'h8e;
        end
        5'd19:
        begin
            Red = 8'h03;
            Green = 8'h27;
            Blue = 8'h69;
        end
        5'd20:
        begin
            Red = 8'h14;
            Green = 8'h44;
            Blue = 8'h91;
        end
        5'd21:
        begin
            Red = 8'h0c;
            Green = 8'h0b;
            Blue = 8'h42;
        end
        5'd22:
        begin
            Red = 8'h48;
            Green = 8'h8b;
            Blue = 8'hd4;
        end
        5'd23:
        begin
            Red = 8'h28;
            Green = 8'hc0;
            Blue = 8'h74;
        end
        5'd24:
        begin
            Red = 8'h10;
            Green = 8'h90;
            Blue = 8'h8e;
        end
        5'd25:
        begin
            Red = 8'h78;
            Green = 8'hd7;
            Blue = 8'hff;
        end
        default:
        begin
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'hff;
        end
    endcase
end

    
endmodule
