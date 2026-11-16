`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/10 19:18:23
// Design Name: 
// Module Name: SIM_TB_RS485
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


module SIM_TB_RS485();

reg clk , rst ;

//定义发送8bit数据
reg     [7:0]                               i_user_tx_data ;
reg                                         i_user_tx_valid;
wire                                        o_user_tx_ready;        

wire                                        w_user_tx_rst   ;
wire                                        w_user_tx_clk   ;
wire                                        uart_data       ;   


//时钟信号
initial begin
    clk <= 'd0;
    rst <= 'd0;
    #105
    @(posedge clk)rst <= 'd1;
end

always begin
    clk <= 0;
    #10;
    clk <= 1;
    #10;
end

uart_tx#
(
	.CLK_FRE        (50),
	.BAUD_RATE      (115200)
) uart_tx_inst
(
	.clk                        (clk                  	        ),
	.rst_n                      (rst                    	    ),
	.tx_data                    (i_user_tx_data                 ),
	.tx_data_valid              (i_user_tx_valid            	),
	.tx_data_ready              (o_user_tx_ready            	),
	.tx_pin                     (                       	    )
);

//产生数据
always @(posedge clk or negedge rst) begin
    if (~rst)
        i_user_tx_data <= 'd0;
    else if (i_user_tx_valid && o_user_tx_ready)
        i_user_tx_data <= i_user_tx_data + 'd1;
    else
        i_user_tx_data <= i_user_tx_data;
end

always @(posedge clk or negedge rst) begin
    if (~rst)
        i_user_tx_valid <= 'd0;
    else if (i_user_tx_valid && o_user_tx_ready)
        i_user_tx_valid <= 'd0;
    else if (o_user_tx_ready)
        i_user_tx_valid <= 'd1;
    else
        i_user_tx_valid <= i_user_tx_valid;
end
endmodule
