//----------------------------------------------------------------------------------------
// File name:           top_hdmi_block_move
// Last modified Date:  2024/11/17
// Last Version:        V1.0
// Descriptions:        HDMI方块移动顶层模块
//----------------------------------------------------------------------------------------
// Created by:          JHHH
// Created date:        2024/11/17
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module  top_hdmi_block_move(
    input          sys_clk,
	input          sys_rst_n,
	
    output         tmds_clk_n,
    output         tmds_clk_p,
    output  [2:0]  tmds_data_n,
    output  [2:0]  tmds_data_p
);

//*****************************************************
//**                    main code
//*****************************************************

//wire define
wire          pixel_clk;
wire          pixel_clk_5x;
(* mark_debug = "true" *)
wire  [10:0]  pixel_xpos_w;
(* mark_debug = "true" *)
wire  [10:0]  pixel_ypos_w;
(* mark_debug = "true" *)
wire  [23:0]  pixel_data_w;
(* mark_debug = "true" *)
wire          video_hs;
(* mark_debug = "true" *)
wire          video_vs;
(* mark_debug = "true" *)
wire          video_de;
(* mark_debug = "true" *)
wire  [23:0]  video_rgb;

//例化MMCM/PLL IP核
clk_wiz_0  clk_wiz_0
(
    // Clock out ports
    .clk_out1     ( pixel_clk ),     // output pixel_clk 75 MHz
    .clk_out2     ( pixel_clk_5x ),  // output pixel_clk_5x 375 MHz
    
	// Status and control signals
    .reset   ( ~sys_rst_n ),                 // input reset
    .locked  (),                             // output locked
    
	// Clock in ports
    .clk_in1 ( sys_clk )                     // input clk_in1
);

//例化RGB数据驱动模块
video_driver  u_video_driver(
    .pixel_clk      ( pixel_clk ),
    .sys_rst_n      ( sys_rst_n ),

    .video_hs       ( video_hs ),
    .video_vs       ( video_vs ),
    .video_de       ( video_de ),
    .video_rgb      ( video_rgb ),
	.data_req		(),

    .pixel_xpos     ( pixel_xpos_w ),
    .pixel_ypos     ( pixel_ypos_w ),
	.pixel_data     ( pixel_data_w )
);

//例化RGB数据显示模块
video_display  u_video_display(
    .pixel_clk      ( pixel_clk ),
    .sys_rst_n      ( sys_rst_n ),

    .pixel_xpos     ( pixel_xpos_w ),
    .pixel_ypos     ( pixel_ypos_w ),
    .pixel_data     ( pixel_data_w )
);

//例化HDMI驱动模块
dvi_transmitter_top u_rgb2dvi_0(
    .pclk           (pixel_clk),
    .pclk_x5        (pixel_clk_5x),
    .reset_n        (sys_rst_n ),
                
    .video_din      (video_rgb),
    .video_hsync    (video_hs), 
    .video_vsync    (video_vs),
    .video_de       (video_de),
                
    .tmds_clk_p     (tmds_clk_p),
    .tmds_clk_n     (tmds_clk_n),
    .tmds_data_p    (tmds_data_p),
    .tmds_data_n    (tmds_data_n), 
    .tmds_oen       ()                    //预留的端口，本次实验未用到
    );


endmodule