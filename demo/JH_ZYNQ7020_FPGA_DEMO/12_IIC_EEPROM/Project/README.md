# 12_IIC_EEPROM

JH-ZYNQ7020-F V1.0 IIC EEPROM 示例，Vivado 2023.1，器件 `xc7z020clg484-2`。

## 工程

- 工程文件：`Project/IIC_EEPROM.xpr`
- 综合顶层：`top_e2prom`
- 仿真顶层：`TB_SIM_EEPROM`
- RTL 模块：`i2c_dri`、`e2prom_rw`、`rw_result_led`，由 `top_e2prom` 连接。
- 仿真源：`Simulation/TB_SIM_EEPROM.v` 与 `Simulation/EEPROM_AT24C64.v`。
- 默认 PL 参考时钟：W17，50 MHz；I2C SCL 参数为 250 kHz。

## 板级连接与限制

- 本例在 PL 侧驱动外接 AT24C64：SCL 接 40PIN IO1_N（W12），SDA 接 IO1_P（V12），模块与开发板共地。
- 板载 AT24C256C 接 PS I2C0（MIO14/SCL、MIO15/SDA），不由本例 PL RTL 直接驱动。
- W12/V12 属于可调 Bank13。根据 2026-11-19 用户提供的实测 VCC_ADJ2 为 3.3 V，`PHY_Pin.xdc` 设置为 `LVCMOS33`；其他板卡或调整 RA 后应重新核实电压。
- `Timing_Constraint.xdc` 只约束 50 MHz 主时钟。RTL 分频生成的 `dri_clk` 尚无经综合网表核验的 generated-clock 约束，本工程不作为时序签核依据。
- `Debug.xdc` 配置 ILA 观察地址、读写数据、应答与完成标志，采样时钟为 `sys_clk`。
- `Bit` 目录包含 Vivado 2023.1 根据本工程生成的 JH 位流及配套 ILA 探针文件。

## 仿真范围

仿真模型将 EEPROM 容量初始化为零；testbench 设置 `MAX_BYTE=3`，演示地址 0 至 2 的单字节写入与读回。testbench 不含自动断言，仿真结果需结合波形观察。
