module VendingMachine (
  input wire clk,           // 时钟信号
  input wire rst,           // 复位信号
  input wire coin1,         // 1元硬币输入信号
  input wire coin2,         // 2元硬币输入信号
  input wire coin5,         // 5元硬币输入信号
  input wire coin10,        // 10元硬币输入信号
  input wire select1,       // 选择商品1信号
  input wire select2,       // 选择商品2信号
  input wire select5,       // 选择商品5信号
  input wire select10,      // 选择商品10信号
  input wire confirm,       // 确认购买信号
  input wire resetTotal,    // 清零销售总额信号

  output reg [3:0] display, // 数码管显示
  output wire alarm,        // 报警信号
  output wire vendSuccess,  // 购买成功信号
  output reg [7:0] change,  // 找零信号
  output reg [7:0] total    // 销售总额
);

// 内部寄存器
reg [7:0] coinBalance;
reg [7:0] price;
reg [1:0] selectedProduct;

// 状态定义
parameter IDLE = 2'b00;
parameter WAIT_FOR_COIN = 2'b01;
parameter WAIT_FOR_CONFIRM = 2'b10;
parameter VENDING = 2'b11;

reg [1:0] state;

// 数码管显示模块
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

// 控制逻辑
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
        // 实现商品出售操作
        // ...
        state <= IDLE;
      end

      default: state <= IDLE;
    endcase
  end
end

// 清零销售总额
always @(posedge clk or posedge rst) begin
  if (resetTotal) total <= 8'b00000000;
end

endmodule
