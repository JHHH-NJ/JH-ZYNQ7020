`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 22:32:59
// Design Name: 
// Module Name: WR_FIFO
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


module WR_FIFO
(
    input           wire        i_clk_100m  ,
    input           wire        i_rst_100m  ,

    input           wire        i_clk_75m   ,
    input           wire        i_rst_75m   ,

    input           wire        i_rd_en     ,   //75M 时钟域
    output          wire        o_fifo_empty,   //75M 时钟域
    output          wire        o_fifo_full     //100M时钟域
);

localparam  P_ST_ILDE     = 1   ,   //在IDLE状态下，如果FIFO为空且75M时钟下同步60个周期后，跳转至写
            P_ST_WR_FIFO  = 2   ;

(* mark_debug = "true" *)
wire    [7:0]       w_fifo_out        ;
(* mark_debug = "true" *)
wire                w_fifo_full       ;
(* mark_debug = "true" *)
wire                w_fifo_empty      ;
(* mark_debug = "true" *)
wire                w_fifo_data_valid ;
wire                w_fifo_full_pos   ;
(* mark_debug = "true" *)
wire                w_fifo_wr_ack     ;

reg     [7:0]       r_st_current      ;
reg     [7:0]       r_st_next         ;
reg     [15:0]      r_st_cnt          ;

(* mark_debug = "true" *)
reg                 r_fifo_wr_en      ;
(* mark_debug = "true" *)
reg     [15:0]      r_fifo_data       ;
reg     [15:0]      r_rst_cnt         ;

reg     [2:0]       r_empty_2d        ;
reg     [2:0]       r_full_2d         ;

reg     [15:0]      r_full_cnt        ; //展宽full信号
reg                 r_full_slow       ; //慢时钟域下的full信号

assign w_fifo_full_pos = w_fifo_full & ~r_full_2d [0];
assign o_fifo_full     = r_full_slow  ;
assign o_fifo_empty    = w_fifo_empty ;

//三段式状态机：第一段跳转
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_st_current <= P_ST_ILDE;
    else
        r_st_current <= r_st_next;
end

//状态机计数器
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_st_cnt <= 'd0;
    else if (r_st_current != r_st_next)
        r_st_cnt <= 'd0;
    else
        r_st_cnt <= r_st_cnt + 'd1;
end

//三段式状态机跳转控制
always @(*) begin
    case (r_st_current)
      P_ST_ILDE: 
          begin
              if (r_empty_2d[2] == 'd1)
                  if (r_rst_cnt == 'd800)
                      r_st_next <= P_ST_WR_FIFO;
                  else
                      r_st_next <= P_ST_ILDE; 
              else
                  r_st_next <= P_ST_ILDE;
          end
      P_ST_WR_FIFO :
          begin
              if (w_fifo_full_pos)
                  r_st_next <= P_ST_ILDE;
              else
                  r_st_next <= P_ST_WR_FIFO;
          end 
      default: r_st_next <= P_ST_ILDE;  
    endcase
end

//空信号在读时钟域下，慢进快直接打两拍进行同步信号
always @(posedge i_clk_100m or posedge i_rst_100m) begin
   if (i_rst_100m)
        r_empty_2d <= 'd0;
    else
        r_empty_2d <= {r_empty_2d[1:0],w_fifo_empty};
end

//IDLE状态下，复位后，需要延迟80个周期进行读写操作，以计数器进行控制
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_rst_cnt <= 'd0;
    else if (r_empty_2d[2] == 'd0) begin
        r_rst_cnt <= 'd0;
    end else if (r_empty_2d[2] == 'd1) begin
        r_rst_cnt <= r_rst_cnt + 'd1;
    end else begin
        r_rst_cnt <= 'd0;
    end
end

//对full信号打两拍，产生上升沿
always @(posedge i_clk_100m or posedge i_rst_100m) begin
   if (i_rst_100m)
        r_full_2d <= 'd0;
    else
        r_full_2d <= {r_full_2d[1:0],w_fifo_full};
end

//写FIFO的状态下，产生写入数据有效
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_fifo_wr_en <= 'd0;
    else if (w_fifo_full_pos)
        r_fifo_wr_en <= 'd0;
    else if (r_st_current == P_ST_WR_FIFO && r_empty_2d[2])
        r_fifo_wr_en <= 'd1;
    else
        r_fifo_wr_en <= r_fifo_wr_en;
end

//写FIFO的状态下，产生写数据
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_fifo_data <= 'd0;
    else if (w_fifo_full_pos)
        r_fifo_data <= 'd0;
    else if (r_st_current == P_ST_WR_FIFO && r_fifo_wr_en)
        r_fifo_data <= r_fifo_data + 'd1;
    else
        r_fifo_data <= r_fifo_data;
end

//full信号跨时钟处理
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_full_cnt <= 'd0;
    else if (r_full_cnt == 'd19)
        r_full_cnt <= 'd0;
    else if (w_fifo_full_pos || r_full_cnt)
        r_full_cnt <= r_full_cnt + 'd1;
    else
        r_full_cnt <= r_full_cnt;
end

//产生慢时钟下的满信号
always @(posedge i_clk_100m or posedge i_rst_100m) begin
    if (i_rst_100m)
        r_full_slow <= 'd0;
    else if (r_full_cnt == 'd19)
        r_full_slow <= 'd0;
    else if (w_fifo_full_pos)
        r_full_slow <= 'd1;
    else
        r_full_slow <= r_full_slow;
end
fifo_generator_0 fifo_generator_0
(
  .rst      (i_rst_100m                           ),       // input wire rst

  .wr_clk   (i_clk_100m                           ),       // input wire wr_clk
  .din      ( r_fifo_data                         ),       // input wire [15 : 0] din
  .wr_en    ( r_fifo_wr_en                        ),       // input wire wr_en

  .rd_clk   (i_clk_75m                            ),       // input wire rd_clk
  .rd_en    (i_rd_en & (~w_fifo_empty)            ),       // input wire rd_en
  .dout     (w_fifo_out                           ),       // output wire [7 : 0] dout

  .full     (w_fifo_full                          ),       // output wire full
  .wr_ack   (w_fifo_wr_ack                        ),       // output wire wr_ack
  .empty    (w_fifo_empty                         ),       // output wire empty
  .valid    (w_fifo_data_valid                    )        // output wire valid
);
endmodule
