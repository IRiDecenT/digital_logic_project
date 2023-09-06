module DisplayModule(input [3:0]displayNum, output reg[7:0]seg);
	// hex digit to 7 seg
	always @(displayNum)
	begin
	seg[7] = 1'b1;
	case(displayNum)
		4'h0: seg[6:0] = ~7'h3F;
		4'h1: seg[6:0] = ~7'h06;
		4'h2: seg[6:0] = ~7'h5B;
		4'h3: seg[6:0] = ~7'h4F;
		4'h4: seg[6:0] = ~7'h66;
		4'h5: seg[6:0] = ~7'h6D;
		4'h6: seg[6:0] = ~7'h7D;
		4'h7: seg[6:0] = ~7'h07;
		4'h8: seg[6:0] = ~7'h7F;
		4'h9: seg[6:0] = ~7'h6F;
		4'ha: seg[6:0] = ~7'h77;
		4'hb: seg[6:0] = ~7'h7C;
		4'hc: seg[6:0] = ~7'h39;
		4'hd: seg[6:0] = ~7'h5E;
		4'he: seg[6:0] = ~7'h79;
		4'hf: seg[6:0] = ~7'h71;
	endcase
	end
endmodule