`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 22:32:59
// Design Name: 
// Module Name: TOP_FIFO_WR_RD
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


module TOP_FIFO_WR_RD
(
    input       wire        i_clk   ,
    input       wire        i_rst_n 
);

wire        w_clk_100M  ;
wire        w_clk_75M   ;
wire        w_locked    ;

wire        w_fifo_rd_en    ;
wire        w_fifo_empty    ;
wire        w_fifo_full     ;

reg     [9:0]   r_100M_rst_cnt      ;
reg     [9:0]   r_75M_rst_cnt       ;
reg             r_rst_75m           ;
reg             r_rst_100m          ;


always@(posedge w_clk_100M) begin
    if (~w_locked) begin
        r_100M_rst_cnt <= 'd0;
        r_rst_100m <=     'd1;
    end else if (r_100M_rst_cnt[9] == 1'b1) begin
        r_100M_rst_cnt <= r_100M_rst_cnt; 
        r_rst_100m     <= 'd0;   
    end else begin
        r_100M_rst_cnt <= r_100M_rst_cnt + 'd1;
        r_rst_100m     <= r_rst_100m;
    end
end

always@(posedge w_clk_75M) begin
    if (~w_locked) begin
        r_75M_rst_cnt <= 'd0;
        r_rst_75m     <= 'd1;
    end else if (r_75M_rst_cnt[9] == 1'b1) begin
        r_75M_rst_cnt <= r_75M_rst_cnt; 
        r_rst_75m     <= 'd0;   
    end else begin
        r_75M_rst_cnt <= r_75M_rst_cnt + 'd1;
        r_rst_75m     <= r_rst_75m;
    end
end

clk_wiz_0 clk_wiz_0_U0
(
    .clk_out1       (w_clk_100M     ),
    .clk_out2       (w_clk_75M      ),

    .locked         (w_locked       ),

    .resetn         (i_rst_n        ), 
    .clk_in1        (i_clk          )
);

WR_FIFO WR_FIFO_U0
(
    .i_clk_100m     (w_clk_100M     ),
    .i_rst_100m     (r_rst_100m     ),

    .i_clk_75m      (w_clk_75M      ),
    .i_rst_75m      (r_rst_75m      ),

    .i_rd_en        (w_fifo_rd_en   ),   //75M 时钟域
    .o_fifo_empty   (w_fifo_empty   ),   //75M 时钟域
    .o_fifo_full    (w_fifo_full    )    //100M时钟域
);

RD_FIFO RD_FIFO_U0
(
    .i_clk_75m      (w_clk_75M      ),
    .i_rst_75m      (r_rst_75m      ),

    .i_fifo_full    (w_fifo_full    ),   //100M时钟域
    .i_fifo_empty   (w_fifo_empty   ),
    .o_rd_fifo_en   (w_fifo_rd_en   )
);
endmodule
