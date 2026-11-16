`timescale 1ns / 1ps

module Breath_LED #(
    parameter [30:0] CNT_2US = 31'd99,
    parameter [30:0] CNT_2MS = 31'd999,
    parameter [30:0] CNT_2S  = 31'd999
) (
    input  wire i_clk,
    input  wire i_rst_n,
    (* mark_debug = "true" *)
    output wire o_led
);

    (* mark_debug = "true" *)
    reg [30:0] r_cnt_2us;
    (* mark_debug = "true" *)
    reg [30:0] r_cnt_2ms;
    (* mark_debug = "true" *)
    reg [30:0] r_cnt_2s;
    (* mark_debug = "true" *)
    reg        r_flag;
    reg        ro_led;

    wire w_tick_2us;
    wire w_end_pwm;
    wire w_led_on;

    assign o_led = ro_led;

    assign w_tick_2us = (r_cnt_2us == CNT_2US);
    assign w_end_pwm = w_tick_2us && (r_cnt_2ms == CNT_2MS);

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_cnt_2us <= 31'd0;
        end else if (w_tick_2us) begin
            r_cnt_2us <= 31'd0;
        end else begin
            r_cnt_2us <= r_cnt_2us + 31'd1;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_cnt_2ms <= 31'd0;
        end else if (w_end_pwm) begin
            r_cnt_2ms <= 31'd0;
        end else if (w_tick_2us) begin
            r_cnt_2ms <= r_cnt_2ms + 31'd1;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_cnt_2s <= 31'd0;
        end else if (w_end_pwm && (r_cnt_2s == CNT_2S)) begin
            r_cnt_2s <= 31'd0;
        end else if (w_end_pwm) begin
            r_cnt_2s <= r_cnt_2s + 31'd1;
        end
    end

    assign w_led_on = r_flag
                    ? (r_cnt_2ms >= r_cnt_2s)
                    : (r_cnt_2ms <= r_cnt_2s);

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            r_flag <= 1'b0;
        end else if (w_end_pwm && (r_cnt_2s == CNT_2S)) begin
            r_flag <= ~r_flag;
        end
    end

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            ro_led <= 1'b0;
        end else begin
            ro_led <= w_led_on;
        end
    end

endmodule
