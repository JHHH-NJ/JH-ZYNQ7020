`timescale 1ns / 1ps
module tb_rs485;
reg clk=0, rst_n=0, rx=1;
wire tx,de;
integer count=0, k;
reg [7:0] expected [0:8];
reg [7:0] got;
localparam BIT_NS=8680;
always #10 clk=~clk;
jh_rs485_top dut(.i_clk(clk),.rst_n(rst_n),.rs485_rx1(rx),.rs485_tx1(tx),.rs485_de1(de));
task send_byte(input [7:0] b);
 integer j;
 begin
  rx=0; #(BIT_NS);
  for(j=0;j<8;j=j+1) begin rx=b[j]; #(BIT_NS); end
  rx=1; #(BIT_NS);
 end
endtask
always @(negedge tx) begin
 if (rst_n && de) begin
  #(BIT_NS + BIT_NS/2);
  for (k=0;k<8;k=k+1) begin got[k]=tx; #(BIT_NS); end
  if (tx !== 1'b1) $fatal(1,"bad stop bit byte %0d",count);
  if (count >= 9) $fatal(1,"unexpected extra byte %h",got);
  if (got !== expected[count]) $fatal(1,"byte %0d expected %h got %h",count,expected[count],got);
  $display("ECHO_PASS index=%0d value=%h time=%0t",count,got,$time);
  count=count+1;
 end
end
initial begin
 expected[0]=8'ha5;
 for(k=1;k<9;k=k+1) expected[k]=k;
 #200; rst_n=1; #(BIT_NS*3);
 send_byte(8'h55); send_byte(8'h00);
 #1500000;
 if (de !== 0 || count != 0) $fatal(1,"zero length unexpectedly transmits");
 $display("ZERO_LENGTH_PASS");
 send_byte(8'h55); send_byte(8'h01); send_byte(8'ha5);
 wait(count==1); wait(de==0); #(BIT_NS*3);
 send_byte(8'h55); send_byte(8'h08);
 for(k=1;k<9;k=k+1) send_byte(k);
 wait(count==9); wait(de==0); #1500000;
 if (count != 9 || de !== 0) $fatal(1,"unexpected final state");
 $display("ALL_CHECKS_PASS zero_length=1 frames=2 bytes=9"); $finish;
end
initial begin #12000000; $fatal(1,"TIMEOUT count=%0d de=%b",count,de); end
endmodule