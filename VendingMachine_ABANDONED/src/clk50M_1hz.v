module clk_1hz(CLK, RST, clk_1Hz);
    input CLK, RST;
    output clk_1Hz;
	 wire clk_1MHz, clk_100KHz, clk_10KHz, clk_1KHz, clk_100Hz, clk_10Hz;
      
    //assign clock = {clk_1MHz, clk_100KHz, clk_10KHz, clk_1KHz, clk_100Hz, clk_10Hz, clk_1Hz};
     
     divide_by_50 d6 (clk_1MHz, CLK, RST);
     divide_by_10 d5 (clk_100KHz, clk_1MHz, RST);
     divide_by_10 d4 (clk_10KHz, clk_100KHz, RST);
     divide_by_10 d3 (clk_1KHz, clk_10KHz, RST);
     divide_by_10 d2 (clk_100Hz, clk_1KHz, RST);
     divide_by_10 d1 (clk_10Hz, clk_100Hz, RST);
     divide_by_10 d0 (clk_1Hz, clk_10Hz, RST);
     
 endmodule



module divide_by_10 (Q, CLK, RST,);
      input CLK, RST;
      output Q;
      reg Q;
      reg [2:0] count;
      
     always @(posedge CLK or negedge RST)
         begin
             if (~RST)
                 begin
                     Q <= 1'b0;
                     count <= 3'b000;
                 end
             else if (count < 4)
                 begin
                     count <= count + 1'b1;
                 end
             else
                 begin
                     count <= 3'b000;
                     Q <= ~Q;
                 end
         end
 
 endmodule


 module divide_by_50 (Q, CLK, RST);
      input CLK, RST;
      output Q;
      reg Q;
      reg [4:0] count;
      
     always @(posedge CLK or negedge RST)
         begin
             if (~RST)
                 begin
                     Q <= 1'b0;
                     count <= 5'b00000;
                 end
             else if (count < 24)
                 begin
                     count <= count + 1'b1;
                 end
             else
                 begin
                     count <= 5'b00000;
                     Q <= ~Q;
                 end
         end
 
 endmodule
