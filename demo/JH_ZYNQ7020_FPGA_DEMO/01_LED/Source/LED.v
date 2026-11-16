module LED
#(
    parameter P_CNT = 'd25_000_000 - 'd1
)(
    input           wire                i_clk   ,
    input           wire                i_rst   ,
    (* mark_debug = "true" *)
    output          wire    [1:0]       o_led   
);

reg     [1:0]       ro_led  ;
(* mark_debug = "true" *)
reg     [30:0]      r_cnt   ;

assign o_led    =   ro_led  ; //以寄存器赋值，对其进行隔离

/* 生成一个周期为500ms的时钟 */
always @(posedge i_clk or negedge i_rst) begin
    if (~i_rst)begin
        r_cnt <= 'd0;
    end else if (r_cnt == P_CNT) begin
        r_cnt <= 'd0;
    end else begin
        r_cnt <= r_cnt + 'd1;
    end
end

/* 当计数器到达500ms，led状态取反 */
always @(posedge i_clk or negedge i_rst) begin
    if (~i_rst)begin
        ro_led <= 2'b10;
    end else if (r_cnt == P_CNT) begin
        ro_led <= ~ro_led;   //按位取反
    end else begin
        ro_led <= ro_led;
    end
end

// ila_0 ila_0_u0
// (
// 	.clk    (i_clk      ),    // input wire clk
// 	.probe0 (r_cnt      ),    // input wire [30:0]  probe0  
// 	.probe1 (o_led      )     // input wire [1:0]  probe1
// );

endmodule
