`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/26 16:08:46
// Design Name: 
// Module Name: SIM_TB_LED
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


module SIM_TB_LED();

reg     clk,rst;    //定义时钟以及复位

//初始化时钟及复位状态
initial begin
    clk <= 'd0;
    rst <= 'd0;
    #100
    rst <= 'd1;
end

//产生测试时钟
always begin
    clk <= 'd0;
    #10;
    clk <= 'd1;
    #10;
end

//例化LED驱动代码
LED
#(
    .P_CNT      (9)     //参数设置为9，为了减少仿真时间，快速观测实验现象
)LED_U0
(
    .i_clk      (clk),
    .i_rst      (rst),

    .o_led      ()
);
endmodule
