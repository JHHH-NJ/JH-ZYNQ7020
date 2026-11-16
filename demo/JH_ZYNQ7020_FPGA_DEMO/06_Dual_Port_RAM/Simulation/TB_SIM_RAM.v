`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/01 22:52:16
// Design Name: 
// Module Name: TB_SIM_RAM
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


module TB_SIM_RAM();

reg clk,rst_n;

initial begin
    clk     <= 'd0;
    rst_n   <= 'd0;
    #100;
    rst_n   <= 'd1;
end

always begin
    clk <= 'd0;
    #10;
    clk <= 'd1;
    #10;
end

RAM_RW_TOP RAM_RW_TOP_U0
(
    .i_clk      (clk),
    .i_rst_n    (rst_n)
);

endmodule
