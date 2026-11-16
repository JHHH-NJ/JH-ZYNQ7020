`timescale 1ns / 1ps

module SIM_TB_Breath_LED;

    reg  clk;
    reg  rst_n;
    wire led;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
    end

    always #10 clk = ~clk;

    initial begin
        #300_000;
        $finish;
    end

    Breath_LED #(
        .CNT_2US (31'd9),
        .CNT_2MS (31'd19),
        .CNT_2S  (31'd29)
    ) u_breath_led (
        .i_clk   (clk),
        .i_rst_n (rst_n),
        .o_led   (led)
    );

endmodule
