`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/27 04:56:02
// Design Name: 
// Module Name: KEY_LED
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


module KEY_LED
#(
    parameter P_LEN = 'd24_999_999
)
(
    input           wire                i_clk   ,
    input           wire                i_rst_n ,
    (* mark_debug = "true" *)
    input           wire    [1:0]       i_key   ,
    (* mark_debug = "true" *)
    output          wire    [1:0]       o_led   
);

reg     [1:0]       ro_led  ;
reg     [30:0]      r_cnt   ;
(* mark_debug = "true" *)
reg                 r_flag  ;

assign o_led  = ro_led;

//产生0.5s计数器
always @(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)
        r_cnt <= 'd0;
    else if (r_cnt == P_LEN) 
        r_cnt <= 'd0;
    else
        r_cnt <= r_cnt + 'd1;
end

//每0.5S产生翻转信号
always @(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)
        r_flag <= 'd0;
    else if (r_cnt == P_LEN) 
        r_flag <= ~r_flag;
    else
        r_flag <= r_flag;
end

//依据输入key信号驱动LED
always @(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n)
        ro_led <= 'd0;
    else 
        case (i_key)
            2'b01: //按键Key 1按下，Key 2未按下，LED交替闪烁
                begin
                    if(r_flag == 0)
                        ro_led <= 2'b10;
                    else
                        ro_led <= 2'b01;
                end
            2'b10: //按键Key 1未按下，Key 2按下，LED同时闪烁
                begin
                    if(r_flag == 0)
                        ro_led <= 2'b00;
                    else
                        ro_led <= 2'b11;
                end
            2'b11: //Key 1、Key 2都未按下，LED灯灭
                begin
                   ro_led <= 2'b00;
                end 
            default: ro_led <= 'd0; 
        endcase
end

endmodule
