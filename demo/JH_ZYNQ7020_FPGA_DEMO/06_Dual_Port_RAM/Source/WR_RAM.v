`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:14:46
// Design Name: 
// Module Name: WR_RAM
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


module WR_RAM
(
    input       wire            i_clk_50m       ,
    input       wire            i_50m_rst       ,
    output      wire            o_ram_full      , //50m时钟下RAM满信号，输出至读模块

    input       wire            i_clk_75m       ,
    (* mark_debug = "true" *)
    input       wire            i_ram_empty     , //75m时钟下RAM空信号，读模块输入
    (* mark_debug = "true" *)
    input       wire    [11:0]  i_ram_addr_b    ,
    (* mark_debug = "true" *)
    output      wire    [7:0]   o_ram_data
);

wire                w_empty_pos     ;  //空信号上升沿

(* mark_debug = "true" *)
reg     [7:0]       r_st_current    ;
reg     [7:0]       r_st_next       ;

(* mark_debug = "true" *)
reg                 r_ram_we        ;   //RAM写有效
(* mark_debug = "true" *)
reg     [10:0]      r_ram_addr      ;   //RAM写地址
(* mark_debug = "true" *)
reg     [15:0]      r_ram_data      ;   //RAM写数据
(* mark_debug = "true" *)
reg                 r_ram_full      ; 
reg     [15:0]      r_ram_wr_cnt    ;   //RAM写数据计数器
reg     [2:0]       ram_empty       ;


localparam P_ST_IDLE    = 8'd1 ,
           P_ST_WR_RAM  = 8'd2 ;

assign w_empty_pos = ram_empty[1] & ~ram_empty[2];
assign o_ram_full  = r_ram_full;

//三段式状态机：将次态赋值给现态
always @(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_st_current <= P_ST_IDLE;
    else
        r_st_current <= r_st_next;
end

//三段式状态机：依据现态编写次态跳转
always @(*) begin
    case (r_st_current)
        P_ST_IDLE:
            begin
                if(w_empty_pos)//当检测至RAM为空的上升沿时，则跳转
                    r_st_next <= P_ST_WR_RAM;
                else
                    r_st_next <= P_ST_IDLE;
            end
        P_ST_WR_RAM: //检测至RAM满信号上升沿则可跳转至IDLE状态
            begin
                if(r_ram_full)
                    r_st_next <= P_ST_IDLE;
                else
                    r_st_next <= P_ST_WR_RAM;  
            end
        default: r_st_next <= P_ST_IDLE;
    endcase
end

//读写控制，1：写;0：读
always@(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_ram_we <= 'd0;
    else if (r_ram_full)
        r_ram_we <= 'd0;
    else if (w_empty_pos)
        r_ram_we <= 'd1;
    else
        r_ram_we <= r_ram_we;
end

//控制RAM写地址
always@(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_ram_addr <= 'd0;
    else if (r_ram_full)
        r_ram_addr <= 'd0;
    else if (r_st_current == P_ST_WR_RAM && r_ram_we)
        r_ram_addr <= r_ram_addr + 'd1;
    else
        r_ram_addr <= r_ram_addr;
end

//控制RAM写数据
always@(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_ram_data <= 'd0;
    else if (r_ram_full)
        r_ram_data <= 'd0;
    else if (r_st_current == P_ST_WR_RAM && r_ram_we)
        r_ram_data <= r_ram_data + 'd2;
    else
        r_ram_data <= r_ram_data;
end

//对写入数据进行计数
always@(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_ram_wr_cnt <= 'd0;
    else if (r_ram_full)
        r_ram_wr_cnt <= 'd0;
    else if (r_st_current == P_ST_WR_RAM && r_ram_we)
        r_ram_wr_cnt <= r_ram_wr_cnt + 'd1;
    else
        r_ram_wr_cnt <= r_ram_wr_cnt;
end

//对跨完时钟的empty打两拍
always @(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        ram_empty <= 'd0;
    else
        ram_empty <= {ram_empty[1:0],i_ram_empty};
end

//写满2048个数据则拉高一个周期
always@(posedge i_clk_50m or posedge i_50m_rst) begin
    if (i_50m_rst)
        r_ram_full <= 'd0;
    else if (r_st_current == P_ST_WR_RAM && r_ram_we && r_ram_wr_cnt == 'd2046)
        r_ram_full <= 'd1;
    else
        r_ram_full <= 'd0;
end

blk_mem_gen_0 blk_mem_gen_0
(
  .clka     (i_clk_50m          ),      // input wire clka
  .wea      (r_ram_we           ),      // input wire [0 : 0] wea
  .addra    (r_ram_addr         ),      // input wire [10 : 0] addra
  .dina     (r_ram_data         ),      // input wire [15 : 0] dina

  .clkb     (i_clk_75m          ),    // input wire clkb
  .addrb    (i_ram_addr_b       ),  // input wire [11 : 0] addrb
  .doutb    (o_ram_data         )  // output wire [7 : 0] doutb
);
endmodule
