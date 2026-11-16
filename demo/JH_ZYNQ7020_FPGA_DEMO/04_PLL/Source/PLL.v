`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 20:18:35
// Design Name: 
// Module Name: PLL
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PLL
(
    input       wire        i_clk   ,
    input       wire        i_rst_n   
);

(* mark_debug = "true" *)
wire    w_locked  ; //指示IP是否锁定

(* mark_debug = "true" *)
wire    w_clk_100M        ;
(* mark_debug = "true" *)
wire    w_clk_100M_90edge;
(* mark_debug = "true" *)
wire    w_clk_50M         ;
(* mark_debug = "true" *)
wire    w_clk_20M         ;

clk_wiz_0 clk_wiz_0_U0
(
  // Clock out ports
  .clk_out1     (w_clk_100M         ),     // output clk_out1
  .clk_out2     (w_clk_100M_90edge ),     // output clk_out2
  .clk_out3     (w_clk_50M          ),     // output clk_out3
  .clk_out4     (w_clk_20M          ),     // output clk_out4

  .locked       (w_locked           ),       // output locked
  
  .reset        ( ~i_rst_n          ),
  .clk_in1      ( i_clk             )      // input clk_in1
);
endmodule
