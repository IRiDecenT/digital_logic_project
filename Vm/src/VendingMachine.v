module VendingMachine(
	input wire clk,           // ʱ���ź�
	input wire rst,           // ��λ�ź�
	input wire coin1,         // 1ԪӲ�������ź�
	input wire coin2,         // 2ԪӲ�������ź�
	input wire coin5,         // 5ԪӲ�������ź�
	input wire coin10,        // 10ԪӲ�������ź�
	input wire select1,       // ѡ����Ʒ1�ź�
	input wire select2,       // ѡ����Ʒ2�ź�
	input wire select5,       // ѡ����Ʒ5�ź�
	input wire select10,      // ѡ����Ʒ10�ź�
	input wire confirm,       // ȷ�Ϲ����ź�
	input wire resetTotal,    // ���������ܶ��ź�

	output[15:0] price_7seg, // the price of item, printed in 7seg
	output[15:0] change_7seg, 
	output[15:0] coinBalance_7seg,
	output[15:0] total_7seg,
	output[3:0] selectItem,  // LED reveal the successfully bought item 
	output alarm       // �����ź�
	// output vendSuccess,  // ����ɹ��ź�
	// output [3:0] change,  // �����ź�
	// output [3:0] total    // �����ܶ� 

);	
	wire clk_1hz;
	
	wire[7:0] price_BCD;
	wire[7:0] coinBalance_BCD;
	wire[7:0] change_BCD;
	wire[7:0] total_BCD; 
	
	wire[6:0] price;
	wire[6:0] coinBalance;
	wire[6:0] change;
	wire[6:0] total;

	clk_1hz clk_1hz_generator(.CLK(clk), .RST(rst), .clk_1Hz(clk_1hz));
		
	ControlModule controlModule(
	.clk(clk_1hz),
	//.clk(clk),
	.rst(rst),
	//.state(state),
	//.price(price),
	//.coinBalance(coinBalance),
	.coin1(coin1),
	.coin2(coin2),
	.coin5(coin5),
	.coin10(coin10),
	.select1(select1),
	.select2(select2),
	.select5(select5),
	.select10(select10),
	.confirm(confirm),
	.resetTotal(resetTotal),
	.price(price),
	.coinBalance(coinBalance),
	.selectItem(selectItem),
	.alarm(alarm),
	//.vendSuccess(vendSuccess),
	.change(change),
	.total(total));
	
	hexBCDconvertModule convert1(.hexNum(price), 
								.hexBCD(price_BCD));
	hexBCDconvertModule convert2(.hexNum(coinBalance),
								.hexBCD(coinBalance_BCD));
	hexBCDconvertModule convert3(.hexNum(change),
								.hexBCD(change_BCD));
	hexBCDconvertModule convert4(.hexNum(total),
								.hexBCD(total_BCD));
								
	// 1 -> shi wei  2 -> ge wei
	DisplayModule displayPrice1(.displayNum(price_BCD[7:4]),
								.seg(price_7seg[15:8]));
	DisplayModule displayPrice2(.displayNum(price_BCD[3:0]),
								.seg(price_7seg[7:0]));
	DisplayModule displayBalance1(.displayNum(coinBalance_BCD[7:4]),
								.seg(coinBalance_7seg[15:8]));							
	DisplayModule displayBalance2(.displayNum(coinBalance_BCD[3:0]),
								.seg(coinBalance_7seg[7:0]));
	DisplayModule displayChange1(.displayNum(change_BCD[7:4]),
								.seg(change_7seg[15:8]));
	DisplayModule displayChange2(.displayNum(change_BCD[3:0]),
								.seg(change_7seg[7:0]));
	DisplayModule displayTotal1(.displayNum(total_BCD[7:4]),
							.seg(total_7seg[15:8]));
	DisplayModule displayTotal2(.displayNum(total_BCD[3:0]),
							.seg(total_7seg[7:0]));																												
endmodule