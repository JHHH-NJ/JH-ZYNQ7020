# JH-ZYNQ7020-F V1.0: Bank33, LVCMOS33
create_clock -period 20.000 -name SYS_CLK -waveform {0.000 10.000} [get_ports i_clk]
set_property PACKAGE_PIN W17 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
set_property PACKAGE_PIN W18 [get_ports i_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst_n]
set_property PACKAGE_PIN V15 [get_ports o_led]
set_property IOSTANDARD LVCMOS33 [get_ports o_led]
