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
	output reg[3:0] price,
	output reg[3:0] coinBalance,
	output reg[3:0] selectItem,
	output reg alarm,
	// output reg vendSuccess,
	output reg[3:0] change,
	output reg[3:0] total
);
	parameter UNSELECTED = 2'b00, SELECTED= 2'b01, WAIT_3SEC = 2'b01;
	// temp var
	reg[1:0] ITEM; // 0 -> 1  1 -> 2  2 -> 5  3 -> 10
	reg [3:0] coinBalance_ = 0;
	reg[3:0] change_ = 0;
	reg[3:0] total_ = 0;
	reg[1:0] state = UNSELECTED;
	
	reg[1:0] counter = 0;
	
	always @(posedge clk or negedge rst)
	begin
		if(~rst)
		begin
			price <= 4'h0;
			coinBalance_ <= 4'h0;
			alarm <= 1'b0;
			state <= UNSELECTED;
			coinBalance <= 0;
			selectItem <= 0;
			change <= 0;
			//total <= 0;
		end
		else if(resetTotal)
		begin
			total_ <= 0;
			total <= 0;
		end
		else
		begin
			case(state)
			UNSELECTED:
			begin
				// init
				price <= 4'h0;
				coinBalance_ <= 4'h0;
				alarm <= 1'b0;
				state <= UNSELECTED;
				coinBalance <= 0;
				selectItem <= 0;
				change <= 0;
				counter <= 0;
				// select
				if(select1)
				begin
					price <= 4'h1;
					state <= SELECTED; 
					ITEM <= 2'h0;
				end
				else if(select2)
				begin
					price <= 4'h2;
					state <= SELECTED; 
					ITEM <= 2'h1;
				end
				else if(select5)
				begin
					price <= 4'h5;
					state <= SELECTED; 
					ITEM <= 2'h2;
				end
				else if(select10)
				begin
					price <= 4'h10; 
					state <= SELECTED; 
					ITEM <= 2'h3;
				end
			end
			SELECTED:
			begin
				if(coin1)	
				begin 
					coinBalance_ <= coinBalance_ + 1;
					coinBalance <= coinBalance_;
					//hexBCDconvertModule converter1(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin2)	
				begin 
					coinBalance_ <= coinBalance_ + 2;
					coinBalance <= coinBalance_;
					//hexBCDconvertModule converter2(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin5)	
				begin 
					coinBalance_ <= coinBalance_ + 5; 
					coinBalance <= coinBalance_;
					//hexBCDconvertModule converter3(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(coin10)	
				begin 
					coinBalance_ <= coinBalance_ + 10;
					coinBalance <= coinBalance_;
					//hexBCDconvertModule converter4(.hexNum(coinBalance), .hexBCD(coinBalance_BCD));
				end
				else if(confirm)
				begin
					if(price <= coinBalance_)
					begin
						change_ <= coinBalance_ - price;
						//hexBCDconvertModule converter5(.hexNum(change), .hexBCD(change_BCD));
						total_ <= total_ + price;
						//hexBCDconvertModule converter6(.hexNum(total), .hexBCD(total_BCD));
						total <= total_;
						change = change_;
						case(ITEM)
							0: selectItem <= 4'b0001;
							1: selectItem <= 4'b0010;
							2: selectItem <= 4'b0100;
							3: selectItem <= 4'b1000;
						endcase
						state <= WAIT_3SEC;
					end
					else
					begin
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
						state <= SELECTED;
				end
				else
					counter <= counter + 1;
			end
			default: state <= UNSELECTED;
			endcase
		end
	end
endmodule