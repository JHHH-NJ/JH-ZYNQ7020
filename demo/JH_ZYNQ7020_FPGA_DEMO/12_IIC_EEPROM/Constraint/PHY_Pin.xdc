# JH-ZYNQ7020-F V1.0 PL clock: W17, 50 MHz; Bank33 is fixed at 3.3 V
set_property PACKAGE_PIN W17 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

# PL_KEY1 is active low; W18 is in fixed 3.3 V Bank33
set_property PACKAGE_PIN W18 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

# 40PIN IO1_N/IO1_P: W12/V12 in adjustable Bank13
set_property PACKAGE_PIN W12 [get_ports iic_scl]
set_property PACKAGE_PIN V12 [get_ports iic_sda]

# Bank13 VCC_ADJ2 must be measured before selecting the bus I/O standard.
# If the physical voltage is confirmed as 3.3 V, enable these lines:
# set_property IOSTANDARD LVCMOS33 [get_ports iic_scl]
# set_property IOSTANDARD LVCMOS33 [get_ports iic_sda]

# PL_LED1 is active high; V15 is in fixed 3.3 V Bank33
set_property PACKAGE_PIN V15 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]
