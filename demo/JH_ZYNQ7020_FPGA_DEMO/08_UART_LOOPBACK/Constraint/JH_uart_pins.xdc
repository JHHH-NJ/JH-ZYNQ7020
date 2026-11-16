# JH-ZYNQ7020-F V1.0 UART loopback test
# Assumption explicitly supplied by the user: Bank13 VCC_ADJ2 is 3.3 V.
set_property PACKAGE_PIN W17 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

set_property PACKAGE_PIN W18 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

# 40PIN IO1 pair: IO1_N=W12, IO1_P=V12
set_property PACKAGE_PIN W12 [get_ports uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_txd]

set_property PACKAGE_PIN V12 [get_ports uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rxd]
