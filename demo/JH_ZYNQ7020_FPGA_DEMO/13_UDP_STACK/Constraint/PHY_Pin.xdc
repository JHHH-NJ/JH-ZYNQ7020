# 本约束依据 JH-ZYNQ7020-F V1.0 管脚表重建。

# JH-ZYNQ7020 V1.0 PL 网口：Bank33，固定 3.3 V
# PL 主时钟与低电平有效复位
set_property PACKAGE_PIN W17 [get_ports {sys_clk}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_clk}]
set_property PACKAGE_PIN W18 [get_ports {sys_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_rst_n}]

# RGMII 接收
set_property PACKAGE_PIN Y19 [get_ports {eth_rxc}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxc}]
set_property PACKAGE_PIN V19 [get_ports {eth_rx_ctl}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rx_ctl}]
set_property PACKAGE_PIN W20 [get_ports {eth_rxd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[0]}]
set_property PACKAGE_PIN W21 [get_ports {eth_rxd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[1]}]
set_property PACKAGE_PIN U20 [get_ports {eth_rxd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[2]}]
set_property PACKAGE_PIN V20 [get_ports {eth_rxd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rxd[3]}]

# RGMII 发送
set_property PACKAGE_PIN AB22 [get_ports {eth_txc}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txc}]
set_property PACKAGE_PIN AB21 [get_ports {eth_tx_ctl}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_tx_ctl}]
set_property PACKAGE_PIN T21 [get_ports {eth_txd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[0]}]
set_property PACKAGE_PIN U21 [get_ports {eth_txd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[1]}]
set_property PACKAGE_PIN AA22 [get_ports {eth_txd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[2]}]
set_property PACKAGE_PIN AA21 [get_ports {eth_txd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_txd[3]}]

# PHY2 复位
set_property PACKAGE_PIN Y21 [get_ports {eth_rst_n}]
set_property IOSTANDARD LVCMOS33 [get_ports {eth_rst_n}]
