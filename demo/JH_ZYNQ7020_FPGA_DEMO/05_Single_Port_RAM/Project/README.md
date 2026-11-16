# 05_Single_Port_RAM 单端口 RAM 读写

器件：`xc7z020clg484-2`；Vivado：2023.1。

本例按第 7 章配置 Block Memory Generator 单端口 RAM，数据宽度 16 bit、深度 2048，读写共用地址端口。控制逻辑先写入地址 0～2047，数据每次加 2；随后顺序读取，并保留一个收尾周期读取最后一个同步 RAM 数据。

- RTL 顶层：`RAM_RW_TOP`；复位低有效。W18 的按键复位异步拉低、经两级寄存器同步释放。
- IP：`Project/IP/blk_mem_gen_0.xci`；2048 × 16，No Change，始终使能，不加载初始化文件。
- 板级引脚：W17 时钟 50 MHz，W18 低有效复位，均为 `LVCMOS33`（Bank33）。时钟周期约束为 20 ns。
- ILA 可观察 `r_we_dbg`、`r_addr_dbg`、`r_data_i_dbg`、`r_read_drain_dbg` 和 `w_data_o`；ILA 核在 Vivado 中按需添加。

本例程根目录已保留 `Project/RAM.xpr` 和 `Bit` 文件夹；原始 IP 配置位于 `Project/IP/blk_mem_gen_0.xci`。
