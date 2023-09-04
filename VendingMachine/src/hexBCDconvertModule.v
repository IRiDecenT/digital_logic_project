module hexBCDconvertModule(input[3:0] hexNum, output reg[7:0] hexBCD);
	always@(hexNum)
	begin
		hexBCD[7:4] <= hexNum / 10;
		hexBCD[3:0] <= hexNum % 10;
	end
endmodule