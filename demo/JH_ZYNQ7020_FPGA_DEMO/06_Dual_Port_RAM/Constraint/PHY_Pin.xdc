# JH-ZYNQ7020-F V1.0: PL clock on W17 and active-low PL_KEY1 on W18.
set_property PACKAGE_PIN W17 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
set_property PACKAGE_PIN W18 [get_ports i_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports i_rst_n]
