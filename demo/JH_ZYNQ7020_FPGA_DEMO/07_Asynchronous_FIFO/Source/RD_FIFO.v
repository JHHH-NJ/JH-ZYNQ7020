`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 22:32:59
// Design Name: 
// Module Name: RD_FIFO
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


module RD_FIFO
(
    input           wire            i_clk_75m   ,
    input           wire            i_rst_75m   ,

    input           wire            i_fifo_full ,   //100M时钟域
    input           wire            i_fifo_empty,
    output          wire            o_rd_fifo_en
);

localparam  P_ST_ILDE     = 1       ,   //在IDLE状态下，如果FIFO检测到满信号，则跳转
            P_ST_RD_FIFO  = 2       ;

wire                w_fifo_full_pos ;
wire                w_fifo_empty_pos;

reg     [7:0]       r_st_current    ;
reg     [7:0]       r_st_next       ;
reg     [15:0]      r_st_cnt        ;

reg     [2:0]       r_fifo_full_2d  ;
reg     [2:0]       r_fifo_empty_2d ;
reg                 r_fifo_rd_en    ;
reg     [7:0]       r_rd_cnt        ;

assign w_fifo_full_pos = r_fifo_full_2d[1] & ~r_fifo_full_2d[2];
assign w_fifo_empty_pos= i_fifo_empty& ~r_fifo_empty_2d[0];
assign o_rd_fifo_en    = r_fifo_rd_en;

//三段式状态机：第一段跳转
always @(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_st_current <= P_ST_ILDE;
    else
        r_st_current <= r_st_next;
end

//状态机计数器
always @(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_st_cnt <= 'd0;
    else if (r_st_current != r_st_next)
        r_st_cnt <= 'd0;
    else
        r_st_cnt <= r_st_cnt + 'd1;
end

//三段式状态机跳转控制
always @(*) begin
    case (r_st_current)
      P_ST_ILDE    : 
          begin
              if (r_rd_cnt == 'd99)
                    r_st_next <= P_ST_RD_FIFO;
              else
                  r_st_next <= P_ST_ILDE;
          end
      P_ST_RD_FIFO :
          begin
              if (w_fifo_empty_pos)
                  r_st_next <= P_ST_ILDE;
              else
                  r_st_next <= P_ST_RD_FIFO;
          end 
      default: r_st_next <= P_ST_ILDE;  
    endcase
end

always @(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_fifo_full_2d <= 'd0;
    else
        r_fifo_full_2d <= {r_fifo_full_2d[1:0],i_fifo_full};
end

always @(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_fifo_empty_2d <= 'd0;
    else
        r_fifo_empty_2d <= {r_fifo_empty_2d[1:0],i_fifo_empty};
end

//产生读FIFO信号
always @(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_fifo_rd_en <= 'd0;
    else if (w_fifo_empty_pos)
        r_fifo_rd_en <= 'd0;
    else if (r_st_current == P_ST_RD_FIFO && r_st_cnt == 'd0)
        r_fifo_rd_en <= 'd1;
    else
        r_fifo_rd_en <= r_fifo_rd_en;
end

always@(posedge i_clk_75m or posedge i_rst_75m) begin
    if (i_rst_75m)
        r_rd_cnt <= 'd0;
    else if (r_rd_cnt == 'd99)
        r_rd_cnt <= 'd0;
    else if (w_fifo_full_pos || r_rd_cnt)
        r_rd_cnt <= r_rd_cnt + 'd1;
    else
        r_rd_cnt <= r_rd_cnt;
end

endmodule
