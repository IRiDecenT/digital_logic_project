module ControlModule(
	input wire clk,
	input wire rst,
	//input wire [1:0] state,
	//input wire [3:0] price,
	//input wire [3:0] coinBalance,
	// input wire [1:0] selectedProduct,
	input wire coin1,
	input wire coin2,
	input wire coin5,
	input wire coin10,
	input wire select1,
	input wire select2,
	input wire select5,
	input wire select10,
	input wire confirm,
	input wire resetTotal,
	output reg[6:0] price,
	output reg[6:0] coinBalance,
	output reg[3:0] selectItem,
	output reg alarm,
	// output reg vendSuccess,
	output reg[6:0] change,
	output reg[6:0] total
);
	parameter UNSELECTED = 2'b00, SELECTED= 2'b01, WAIT_3SEC = 2'b10;
	// temp var
	reg[1:0] ITEM; // 0 -> 1  1 -> 2  2 -> 5  3 -> 10
	//reg [6:0] coinBalance_ ;
	//reg[6:0] change_;
	//reg[6:0] total_;
	reg[1:0] state = UNSELECTED;
	
	reg[1:0] counter = 0;
	
	always @(posedge clk or negedge rst)
	begin
		if(~rst)
		begin
			price <= 7'h0;
			//coinBalance_ <= 7'd0;
			alarm <= 1'b0;
			state <= UNSELECTED;
			coinBalance <= 7'b0;
			selectItem <= 7'b0;
			change <= 7'b0;
			//total <= 0;
		end
		else if(resetTotal)
		begin
			//total_ <= 7'b0;
			total <= 7'b0;
		end
		else
		begin
			case(state)
			UNSELECTED:
			begin
				// init
				price <= 7'b0;
				//coinBalance_ <= 7'b0;
				alarm <= 1'b0;
				state <= UNSELECTED;
				coinBalance <= 7'b0;
				selectItem <= 4'b0;
				change <= 7'b0;
				counter <= 0;
				// select
				if(select1)
				begin
					price <= 7'b0000001;
					state <= SELECTED; 
					ITEM <= 2'd0;
				end
				else if(select2)
				begin
					price <= 7'b0000010;
					state <= SELECTED; 
					ITEM <= 2'd1;
				end
				else if(select5)
				begin
					price <= 7'b0000101;
					state <= SELECTED; 
					ITEM <= 2'd2;
				end
				else if(select10)
				begin
					price <= 7'b0001010; 
					state <= SELECTED; 
					ITEM <= 2'd3;
				end
			end
			SELECTED:
			begin
				if(coin1)	
				begin 
					//coinBalance_ <= coinBalance_ + 1;
					coinBalance <= coinBalance + 1;
					//hexBCDconvertModule converter1(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin2)	
				begin 
					//coinBalance_ <= coinBalance_ + 2;
					coinBalance <= coinBalance + 2;
					//hexBCDconvertModule converter2(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin5)	
				begin 
					//coinBalance_ <= coinBalance_ + 5; 
					coinBalance <= coinBalance + 5;
					//hexBCDconvertModule converter3(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin10)	
				begin 
					//coinBalance_ <= coinBalance_ + 10;
					coinBalance <= coinBalance + 10;
					//hexBCDconvertModule converter4(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				if(confirm)
				begin
					if(price <= coinBalance)
					begin
						//change_ <= coinBalance - price;
						//hexBCDconvertModule converter5(.hexNum(change), .hexBCD(change_BCD));
						total <= total + price;
						change <= coinBalance - price;
						//hexBCDconvertModule converter6(.hexNum(total), .hexBCD(total_BCD));
						//total <= total_;
						//change <= change_;
						case(ITEM)
							0: selectItem <= 4'b0001;
							1: selectItem <= 4'b0010;
							2: selectItem <= 4'b0100;
							3: selectItem <= 4'b1000;
						endcase
						//total <= total_;
						state <= WAIT_3SEC;
					end
					else
					begin
						change <= coinBalance;
						state <= WAIT_3SEC;
						alarm <= 1'b1;
						
						//selectItem <= selectItem & 4'b0000;
					end
				end
			end
			// time counter  3 sec
			WAIT_3SEC:
			begin
				if(~rst) counter <= 0;
				if(counter == 3)
				begin
					counter <= 0;
					if(~alarm)
						state <= UNSELECTED;
					else
					begin
						state <= UNSELECTED;
					end
				end
				else
					counter <= counter + 1;
			end
			default: state <= UNSELECTED;
			endcase
		end
	end
endmodule