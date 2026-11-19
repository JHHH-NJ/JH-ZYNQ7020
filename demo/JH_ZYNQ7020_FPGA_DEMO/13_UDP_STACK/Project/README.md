# 13_UDP_STACK

JH-ZYNQ7020-F V1.0 PL 端以太网 UDP 回环示例，沿用现有示例库的 `Source`、`Simulation`、`Constraint`、`Project`、`Bit` 目录结构。

## 工程

- Vivado 2023.1；器件 `xc7z020clg484-2`。
- 工程文件：`Project/UDP_STACK.xpr`；综合顶层：`eth_udp_loop`。
- 仿真顶层：`TB_SIM_ARP`、`TB_SIM_UDP`，分别选择后运行。
- IP：`clk_wiz_0`、`async_fifo_2048x8b`，配置文件位于 `Project/UDP_STACK.srcs/sources_1/ip/`。
- 源码和 testbench 基于 `RK_XC7Z020_FPGA_DEMO/13_UDP_STACK` 对应文件，`Created by` 署名已统一为 `JHHH`；板级 `PHY_Pin.xdc` 使用 JH-ZYNQ7020-F V1.0 的 PHY2 引脚表。

## 板级接口

- PL 以太网：开发板下方 RJ2（PHY2），RGMII，管脚约束位于 `Constraint/PHY_Pin.xdc`。
- 时钟约束：`Constraint/Timing_Constraint.xdc` 中 `sys_clk` 为 50 MHz，`eth_rxc` 按 1 Gbps RGMII 的 125 MHz 约束。
- 调试探针：`Constraint/Debug.xdc` 设置 GMII TX/RX 数据及有效信号的 ILA 探针。
- 示例地址：开发板 `192.168.1.10`，上位机 `192.168.1.102`，UDP 端口 `1234`。

## 工程文件

`Project/UDP_STACK.srcs` 保留 XPR 直接引用的 IP 配置和综合检查点；Vivado 生成的 `.cache`、`.gen`、`.runs`、`.sim` 和 `.hw` 目录未复制。首次打开工程时，按 Vivado 提示重新生成 IP 输出产品和运行文件。

预置位流文件及 ILA 探针文件在 `Bit/`；如果修改 RTL 或 XDC，重新综合和实现后再使用新生成的文件。