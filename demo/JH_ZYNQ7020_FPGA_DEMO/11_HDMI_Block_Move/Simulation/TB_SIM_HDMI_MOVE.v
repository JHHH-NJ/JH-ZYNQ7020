//----------------------------------------------------------------------------------------
// File name:           TB_SIM_HDMI_MOVE
// Last modified Date:  2024/11/17
// Last Version:        V1.0
// Descriptions:        用于实现HDMI方块仿真
//----------------------------------------------------------------------------------------
// Created by:          JHHH
// Created date:        2024/11/17
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//


module TB_SIM_HDMI_MOVE();

reg          sys_clk	;
reg          sys_rst_n	;
						
wire         tmds_clk_n	;
wire         tmds_clk_p	;
wire  [2:0]  tmds_data_n;
wire  [2:0]  tmds_data_p;

initial begin
	sys_clk = 1'b1;
	sys_rst_n <= 1'b0;
	#201
	sys_rst_n <= 1'b1;
end

always #10 sys_clk <= ~sys_clk;

defparam top_hdmi_block_move_inst.u_video_display.DIV_CNT = 75;

top_hdmi_block_move top_hdmi_block_move_inst(
    .sys_clk	(sys_clk	),
	.sys_rst_n	(sys_rst_n	),

    .tmds_clk_n	(tmds_clk_n	),
    .tmds_clk_p	(tmds_clk_p	),
    .tmds_data_n(tmds_data_n),
    .tmds_data_p(tmds_data_p)
);

endmodule
