`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:14:46
// Design Name: 
// Module Name: RD_RAM
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


module RD_RAM
(
    input       wire            i_clk_75m   ,
    input       wire            i_75m_rst   ,

    input       wire            i_ram_full  ,
    output      wire            o_ram_empty ,
    output      wire    [11:0]  o_ram_addr  
);

localparam  P_ST_IDLE    = 8'd1 ,
            P_ST_RD_RAM  = 8'd2 ;

wire                            w_ram_full_pos  ;
wire                            w_ram_empty_pos ;

reg         [7:0]               r_st_current    ;
reg         [7:0]               r_st_next       ;
reg         [15:0]              r_st_cnt        ;

reg         [11:0]              r_ram_addr      ;
reg         [2:0]               r_ram_full      ;
reg         [15:0]              r_ram_rd_cnt    ;

reg                             r_ram_empty     ;
reg         [15:0]              r_ram_empty_cnt ;
reg                             r_ram_empty_slow;
reg         [2:0]               r_ram_empty_2d  ;

assign w_ram_full_pos = r_ram_full[1] & ~r_ram_full[2]; 
assign w_ram_empty_pos= r_ram_empty &~r_ram_empty_2d[0];
assign o_ram_empty    = r_ram_empty_slow;
assign o_ram_addr     = r_ram_addr;

//full信号由慢时钟进快时钟直接打两拍进行信号同步
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_full <= 'd0;
    else
        r_ram_full <= {r_ram_full[1:0],i_ram_full};
end

//状态机计数
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_st_cnt <= 'd0;
    else if (r_st_current != r_st_next)
        r_st_cnt <= 'd0;
    else
        r_st_cnt <= r_st_cnt + 'd1;
end
//三段式状态机：将次态赋值给现态
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_st_current <= P_ST_IDLE;
    else
        r_st_current <= r_st_next;
end

//三段式状态机：依据现态编写次态跳转
always @(*) begin
    case (r_st_current)
        P_ST_IDLE:
            begin
                if(w_ram_full_pos)//当检测至RAM为满的上升沿时，则跳转
                    r_st_next <= P_ST_RD_RAM;
                else
                    r_st_next <= P_ST_IDLE;
            end
        P_ST_RD_RAM: //检测至RAM空信号上升沿则可跳转至IDLE状态
            begin
                if(w_ram_empty_pos)
                    r_st_next <= P_ST_IDLE;
                else
                    r_st_next <= P_ST_RD_RAM;  
            end
        default: r_st_next <= P_ST_IDLE;
    endcase
end

//控制读RAM地址
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_addr <= 'd0;
    else if (r_ram_addr == 'd4094)
        r_ram_addr <= 'd0;
    else if (r_st_current == P_ST_RD_RAM && (r_ram_empty_slow == 1'b0))
        r_ram_addr <= r_ram_addr + 'd1;
    else
        r_ram_addr <= r_ram_addr;
end

//控制读数据计数器
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_rd_cnt <= 'd0;
    else if (r_ram_rd_cnt == 'd4095)
        r_ram_rd_cnt <= 'd0;
    else if (r_st_current == P_ST_RD_RAM && (r_ram_empty_slow == 1'b0))
        r_ram_rd_cnt <= r_ram_rd_cnt + 'd1;
    else
        r_ram_rd_cnt <= r_ram_rd_cnt;
end

//控制输出空信号
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_empty <= 'd1;
    else if (r_st_current == P_ST_RD_RAM && r_ram_rd_cnt == 'd4093)
        r_ram_empty <= 'd1;
    else if (w_ram_full_pos)
        r_ram_empty <= 'd0;
    else 
        r_ram_empty <= r_ram_empty;
end

//打两拍
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_empty_2d <= 'd1;
    else 
        r_ram_empty_2d <= {r_ram_empty_2d[1:0],r_ram_empty};
end

//empty信号需要从快时钟进满时钟所以将其延展20个时钟周期，方便慢时钟采集
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_empty_cnt <= 'd0;
    else if (r_ram_empty_cnt == 'd19)
        r_ram_empty_cnt <= 'd0;
    else if (w_ram_empty_pos || r_ram_empty_cnt)
        r_ram_empty_cnt <= r_ram_empty_cnt + 'd1;
    else 
        r_ram_empty_cnt <= r_ram_empty_cnt;
end

//延展empty信号
always @(posedge i_clk_75m or posedge i_75m_rst) begin
    if (i_75m_rst)
        r_ram_empty_slow <= 'd1;
    else if (r_st_current == P_ST_RD_RAM && r_st_cnt == 'd0)
        r_ram_empty_slow <= 'd0;
    else if (r_st_current == P_ST_RD_RAM && w_ram_empty_pos)
        r_ram_empty_slow <= 'd1;
    else 
        r_ram_empty_slow <= r_ram_empty_slow;
end

endmodule
