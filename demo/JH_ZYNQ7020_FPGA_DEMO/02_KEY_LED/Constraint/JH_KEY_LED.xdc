# JH-ZYNQ7020-F V1.0
# W12 is on adjustable Bank13 (VCC_ADJ2). This file assumes the documented
# default VCC_ADJ2=3.3V; if the board RA resistor selects another voltage,
# change these LVCMOS33 standards to match the measured Bank13 voltage.
create_clock -period 20.000 -name SYS_CLK -waveform {0.000 10.000} [get_ports i_clk]
set_property PACKAGE_PIN W17 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]

# PL_KEY1 is i_key[0]; PL_KEY2 is i_key[1]. Both are active low.
set_property PACKAGE_PIN W18 [get_ports {i_key[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[0]}]
set_property PACKAGE_PIN V14 [get_ports {i_key[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_key[1]}]

# External active-low reset via 40PIN IO1_N (Bank13, adjustable VCC_ADJ2).
set_property PACKAGE_PIN W12 [get_ports i_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst_n]

set_property PACKAGE_PIN V15 [get_ports {o_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_led[0]}]
set_property PACKAGE_PIN V13 [get_ports {o_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_led[1]}]
