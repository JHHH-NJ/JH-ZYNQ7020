# 07_Asynchronous_FIFO 异步 FIFO 与位宽转换

器件：`xc7z020clg484-2`；Vivado：2023.1。

本例使用 100 MHz 写时钟和 75 MHz 读时钟，将 16 位数据写入 FIFO，再按 8 位顺序读出。例程目录包含 FIFO 与时钟 IP 配置、RTL 和板级约束。

- 顶层：`TOP_FIFO_WR_RD`
- IP：`Project/IP/clk_wiz_0/clk_wiz_0.xci`、`Project/IP/fifo_generator_0/fifo_generator_0.xci`
- 管脚：W17 为 50 MHz 输入时钟；W18 为低有效复位输入。两个端口均约束为 LVCMOS33。
- 时钟约束：50 MHz 输入时钟由 Clocking Wizard 生成的 XDC 提供；不要重复添加 `create_clock`。`Timing_Constraint.xdc` 保存 Debug Hub 时钟设置，`Debug.xdc` 配置两个 ILA。

本例程根目录已保留 `Project/FIFO.xpr` 和 `Bit` 产物；原始 IP 配置位于 `Project/IP`，工程内生成的 IP 和运行结果保留在 `Project`。

当前 RTL 中 `WR_FIFO.i_rst_75m` 端口未使用；FIFO IP 的复位连接 `i_rst_100m`。示例用固定等待时间处理复位，实际设计应按 FIFO Generator 的复位要求验证。
