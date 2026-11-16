`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/02 12:14:46
// Design Name: 
// Module Name: RAM_RW_TOP
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


module RAM_RW_TOP
(
    input       wire        i_clk   ,
    input       wire        i_rst_n 
);

wire            w_clk_50m       ;
wire            w_clk_75m       ;
wire            w_pll_lock      ;

wire            w_ram_full      ;
wire            w_ram_empty     ;
wire    [11:0]  w_ram_addr      ;
wire    [7:0]   w_ram_data      ;

reg     [9:0]   r_50M_rst_cnt   ;
reg     [9:0]   r_75M_rst_cnt   ;
reg             r_rst_75m       ;
reg             r_rst_50m       ;
(* ASYNC_REG = "TRUE" *) reg [1:0] r_rst_n_sync;
wire            w_rst_n;

always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)
        r_rst_n_sync <= 2'b00;
    else
        r_rst_n_sync <= {r_rst_n_sync[0], 1'b1};
end
assign w_rst_n = r_rst_n_sync[1];

always@(posedge w_clk_50m) begin
    if (~w_pll_lock) begin
        r_50M_rst_cnt <= 'd0;
        r_rst_50m <=     'd1;
    end else if (r_50M_rst_cnt[9] == 1'b1) begin
        r_50M_rst_cnt <= r_50M_rst_cnt; 
        r_rst_50m     <= 'd0;   
    end else begin
        r_50M_rst_cnt <= r_50M_rst_cnt + 'd1;
        r_rst_50m     <= r_rst_50m;
    end
end

always@(posedge w_clk_75m) begin
    if (~w_pll_lock) begin
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

clk_wiz_0 clk_wiz_0
(

    .clk_out1           (w_clk_50m      ),     // output clk_out1
    .clk_out2           (w_clk_75m      ),     // output clk_out2

    .resetn             (w_rst_n        ), 
    .locked             (w_pll_lock     ),       // output locked

    .clk_in1            (i_clk          )      // input clk_in1
);

WR_RAM WR_RAM_U0
(
    .i_clk_50m          (w_clk_50m      ),
    .i_50m_rst          (r_rst_50m      ),
    .o_ram_full         (w_ram_full     ), //50m时钟下RAM满信号，输出至读模块

    .i_clk_75m          (w_clk_75m      ),
    .i_ram_empty        (w_ram_empty    ), //75m时钟下RAM空信号，读模块输入
    .i_ram_addr_b       (w_ram_addr     ),
    .o_ram_data         (w_ram_data     )
);

RD_RAM RD_RAM_U0
(
    .i_clk_75m          (w_clk_75m      ),
    .i_75m_rst          (r_rst_75m      ),

    .i_ram_full         (w_ram_full     ),
    .o_ram_empty        (w_ram_empty    ),
    .o_ram_addr         (w_ram_addr     )
);

endmodule
