# 06_Dual_Port_RAM 双端口 RAM 读写

器件：`xc7z020clg484-2`；Vivado：2023.1。

本例按第 8 章配置简单双端口 RAM。Port A 以 50 MHz 写入 2048 个 16 bit 数据，Port B 以 75 MHz 按 8 bit 读出 4096 个数据；两个时钟由同一个 Clock Wizard 产生，状态机协调整轮读写。

- RTL 顶层：`RAM_RW_TOP`；写控制：`WR_RAM`；读控制：`RD_RAM`。W18 的按键复位异步拉低、经两级寄存器同步释放。
- IP：`Project/IP/blk_mem_gen_0.xci`（A 口 2048 × 16 写、B 口 4096 × 8 读，独立时钟）；`Project/IP/clk_wiz_0.xci`（50 MHz 输入，输出 50 MHz 和 75 MHz）。
- 板级引脚：W17 时钟 50 MHz，W18 低有效复位，均为 `LVCMOS33`（Bank33）。输入时钟约束为 20 ns；Clock Wizard 为相关输出时钟提供 IP 约束，不添加异步时钟组。
- RTL 已标记部分 ILA 调试信号；需要上板观察时，在 Vivado 中按第 8 章添加 ILA。

本例程根目录已保留 Vivado 工程和 `Bit` 产物；原始 IP 配置位于 `Project/IP`。
