`timescale 1ns/1ps
// Simulation-ready copy of the Chapter 07 RAM controller excerpt.
// Syntax and declarations are completed; a one-cycle read drain preserves the last BMG word.
module RAM_RW_TOP (
  input  wire        i_clk,
  input  wire        i_rst_n,
  output wire        r_we_dbg,
  output wire [10:0] r_addr_dbg,
  output wire [15:0] r_data_i_dbg,
  output wire        r_read_drain_dbg,
  output wire [15:0] w_data_o
);
  reg [10:0] r_wr_en_cnt;
  reg        r_we;
  reg [10:0] r_addr;
  reg [15:0] r_data_i;
  reg        r_read_drain;
  wire       w_ram_we;
  wire       w_rst_n;
  (* ASYNC_REG = "TRUE" *) reg [1:0] r_rst_n_sync;

  assign w_ram_we          = w_rst_n & r_we;
  assign r_we_dbg          = r_we;
  assign r_addr_dbg        = r_addr;
  assign r_data_i_dbg      = r_data_i;
  assign r_read_drain_dbg  = r_read_drain;

  // Assert reset asynchronously from PL_KEY1 and release it synchronously.
  always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n)
      r_rst_n_sync <= 2'b00;
    else
      r_rst_n_sync <= {r_rst_n_sync[0], 1'b1};
  end

  assign w_rst_n = r_rst_n_sync[1];

  // The document describes a write pass followed by a read pass.
  // Keep the controller's original 2048-address counter.
  always @(posedge i_clk or negedge w_rst_n) begin
    if (!w_rst_n)
      r_wr_en_cnt <= 11'd0;
    else if ((r_wr_en_cnt == 11'd2047) || r_read_drain)
      r_wr_en_cnt <= 11'd0;
    else
      r_wr_en_cnt <= r_wr_en_cnt + 11'd1;
  end

  always @(posedge i_clk or negedge w_rst_n) begin
    if (!w_rst_n)
      r_read_drain <= 1'b0;
    else if ((r_wr_en_cnt == 11'd2047) && !r_we)
      r_read_drain <= 1'b1;
    else if (r_read_drain)
      r_read_drain <= 1'b0;
  end

  always @(posedge i_clk or negedge w_rst_n) begin
    if (!w_rst_n)
      r_we <= 1'b1;
    else if (r_read_drain)
      r_we <= 1'b1;
    else if ((r_wr_en_cnt == 11'd2047) && r_we)
      r_we <= 1'b0;
  end

  always @(posedge i_clk or negedge w_rst_n) begin
    if (!w_rst_n)
      r_addr <= 11'd0;
    else if (r_read_drain)
      r_addr <= 11'd0;
    else if (r_wr_en_cnt == 11'd2047) begin
      if (r_we)
        r_addr <= 11'd0;
    end else
      r_addr <= r_addr + 11'd1;
  end

  always @(posedge i_clk or negedge w_rst_n) begin
    if (!w_rst_n)
      r_data_i <= 16'd0;
    else if (r_wr_en_cnt == 11'd2047)
      r_data_i <= 16'd0;
    else if (r_we)
      r_data_i <= r_data_i + 16'd2;
  end

  blk_mem_gen_0 blk_mem_gen_0_u0 (
    .clka  (i_clk),
    .wea   (w_ram_we),
    .addra (r_addr),
    .dina  (r_data_i),
    .douta (w_data_o)
  );
endmodule
