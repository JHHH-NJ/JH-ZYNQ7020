`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 21:26:51
// Design Name: 
// Module Name: SIM_TB_PLL
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


module SIM_TB_PLL();

reg         clk,rst;

//初始化时钟与复位信号
initial begin
    clk <= 'd0;
    rst <= 'd0;
    #100
    rst <= 'd1;   
end

//产生50Mhz的时钟
always begin
    clk <= 'd0;
    #10;
    clk <= 'd1;
    #10;
end

//例化IP
PLL PLL_U0
(
    .i_clk   (clk),
    .i_rst_n (rst)
);
endmodule
