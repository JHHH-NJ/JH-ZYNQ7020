`timescale 1ns / 1ps
module jh_rs485_top(input i_clk, input rst_n, input rs485_rx1, output rs485_tx1, output rs485_de1);
  (* ASYNC_REG = "TRUE" *) reg [1:0] reset_sync;
  always @(posedge i_clk or negedge rst_n)
    if (!rst_n) reset_sync <= 2'b00;
    else reset_sync <= {reset_sync[0], 1'b1};
  uart_test u_rs485(.sys_clk(i_clk), .rst_n(reset_sync[1]), .rs485_rx(rs485_rx1), .rs485_tx(rs485_tx1), .rs485_de(rs485_de1));
endmodule