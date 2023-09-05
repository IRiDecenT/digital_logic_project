module hexBCDconvertModule(input[6:0] hexNum, output reg[7:0] hexBCD);
	/*
	reg[3:0] tens;
	reg[3:0] ones;
	integer i;
	always@(hexNum)
	begin
		for( i = 6; i >= 0; i = i - 1)
		begin
			if(ones >= 4'd5)	ones = ones + 4'd3;
			if(tens >= 4'd5)	tens = tens + 4'd3;
			tens = {tens[2:0], ones[3]};
			ones = {ones[2:0], hexNum[i]};
		end
		
		hexBCD = {tens, ones};
	end
	*/
	always@(hexNum)
	begin
		hexBCD[7:4] = hexNum / 10;
		hexBCD[3:0] = hexNum % 10;
	end
endmodule