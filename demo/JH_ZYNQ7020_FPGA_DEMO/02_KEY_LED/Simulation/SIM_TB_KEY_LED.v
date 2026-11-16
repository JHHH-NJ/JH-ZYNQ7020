`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 05:29:04
// Design Name: 
// Module Name: SIM_TB_KEY_LED
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


module SIM_TB_KEY_LED();

reg clk,rst_n;  //定义时钟及复位

reg [1:0] key;  //定义按键

//初始化时钟及复位
initial begin
    clk   <= 'd0;
    rst_n <= 'd0;
    #100
    rst_n <= 'd1;    
end

//产生测试时钟
always begin
    clk <= 'd0;
    #10;
    clk <= 'd1;
    #10;
end

//产生按键值
initial begin
    key   <= 2'b00;
    #200
    key   <= 2'b10;
    #200
    key   <= 2'b01;
    #200
    key   <= 2'b11;
end

KEY_LED
#(
    .P_LEN   ('d9)
)KEY_LED_U0
(
    .i_clk   ( clk      ),
    .i_rst_n ( rst_n    ),

    .i_key   (  key     ),
    .o_led   ()
);
endmodule
