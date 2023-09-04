module VendingMachine (
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

  output reg [3:0] display, // �������ʾ
  output wire alarm,        // �����ź�
  output wire vendSuccess,  // ����ɹ��ź�
  output reg [7:0] change,  // �����ź�
  output reg [7:0] total    // �����ܶ�
);

// �ڲ��Ĵ���
reg [7:0] coinBalance;
reg [7:0] price;
reg [1:0] selectedProduct;

// ״̬����
parameter IDLE = 2'b00;
parameter WAIT_FOR_COIN = 2'b01;
parameter WAIT_FOR_CONFIRM = 2'b10;
parameter VENDING = 2'b11;

reg [1:0] state;

// �������ʾģ��
always @(posedge clk or posedge rst) begin
  if (rst) begin
    display <= 4'b0000;
  end else begin
    case (state)
      IDLE:   display <= price;
      WAIT_FOR_COIN: display <= coinBalance;
      WAIT_FOR_CONFIRM: display <= price;
      VENDING: display <= 4'b0000;
      default: display <= 4'b0000;
    endcase
  end
end

// �����߼�
always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= IDLE;
    coinBalance <= 8'b00000000;
    price <= 8'b00000000;
    selectedProduct <= 2'b00;
    alarm <= 1'b0;
    vendSuccess <= 1'b0;
    change <= 8'b00000000;
    total <= 8'b00000000;
  end else begin
    case (state)
      IDLE: begin
        if (select1) begin
          price <= 8'b00000001;
          selectedProduct <= 2'b01;
          state <= WAIT_FOR_COIN;
        end else if (select2) begin
          price <= 8'b00000010;
          selectedProduct <= 2'b10;
          state <= WAIT_FOR_COIN;
        end else if (select5) begin
          price <= 8'b00000101;
          selectedProduct <= 2'b11;
          state <= WAIT_FOR_COIN;
        end else if (select10) begin
          price <= 8'b00001010;
          selectedProduct <= 2'b00;
          state <= WAIT_FOR_COIN;
        end
      end

      WAIT_FOR_COIN: begin
        if (coin1) coinBalance <= coinBalance + 1;
        if (coin2) coinBalance <= coinBalance + 2;
        if (coin5) coinBalance <= coinBalance + 5;
        if (coin10) coinBalance <= coinBalance + 10;
        if (confirm) begin
          if (coinBalance >= price) begin
            state <= VENDING;
            change <= coinBalance - price;
            vendSuccess <= 1'b1;
            total <= total + price;
          end else begin
            state <= IDLE;
            alarm <= 1'b1;
          end
        end
      end

      WAIT_FOR_CONFIRM: begin
        if (confirm) begin
          state <= IDLE;
          coinBalance <= 8'b00000000;
        end
      end

      VENDING: begin
        // ʵ����Ʒ���۲���
        // ...
        state <= IDLE;
      end

      default: state <= IDLE;
    endcase
  end
end

// ���������ܶ�
always @(posedge clk or posedge rst) begin
  if (resetTotal) total <= 8'b00000000;
end

endmodule
