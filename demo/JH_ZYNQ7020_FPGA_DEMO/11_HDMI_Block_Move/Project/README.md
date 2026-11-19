# 11_HDMI_Block_Move

JH-ZYNQ7020-F V1.0 的 720p HDMI 方块移动实验，沿用 10_HDMI_ColorBar 的 JH 板级管脚和 HDMI 显示链路。

## 工程设置

- Vivado 2023.1；器件 xc7z020clg484-2。
- 工程文件：Project/HDMI_Block_Move.xpr；顶层：top_hdmi_block_move；仿真顶层：TB_SIM_HDMI_MOVE。
- Clock Wizard 输入 50 MHz，输出 pixel_clk 75 MHz、pixel_clk_5x 375 MHz。
- 默认 DIV_CNT 为 750000；仿真 testbench 覆盖为 75，以缩短移动间隔。
- Constraint/PHY_Pin.xdc 使用 JH HDMI 管脚；Debug.xdc 与 Timing_Constraint.xdc 沿用 JH 彩条工程的 ILA 设置。

## 目录

- Source：顶层、像素驱动、方块绘制和 TMDS 编码源码。
- Simulation：TB_SIM_HDMI_MOVE 仿真文件。
- Constraint：JH 板级 HDMI 引脚及调试约束。
- Project：Vivado XPR 与 Clock Wizard XCI。
- Bit：预留位流输出目录。未复制其他板卡的预编译位流，避免误用于 JH 管脚。

本例没有打包 Vivado 缓存、综合/实现运行目录或仿真生成文件；Bit 目录目前只有说明文件。打开 XPR 后按需生成 IP 输出产品和位流。