`timescale 1ns/1ps
module tb_ram_cycles;
reg clk = 0;
reg rst_n = 0;
wire we, read_drain;
wire [10:0] addr;
wire [15:0] din, dout;
always #10 clk = ~clk;
RAM_RW_TOP dut (.i_clk(clk), .i_rst_n(rst_n), .r_we_dbg(we),
 .r_addr_dbg(addr), .r_data_i_dbg(din), .r_read_drain_dbg(read_drain), .w_data_o(dout));
initial begin
 #65 rst_n = 1;
 #249935 $finish;
end
endmodule
