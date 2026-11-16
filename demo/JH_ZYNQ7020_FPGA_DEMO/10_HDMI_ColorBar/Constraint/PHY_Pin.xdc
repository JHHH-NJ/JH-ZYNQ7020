# JH-ZYNQ7020-F V1.0 HDMI board pins; Bank 33 is fixed at 3.3 V.
# PL reference clock and active-low PL_KEY1 reset.
set_property PACKAGE_PIN W17 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property PACKAGE_PIN W18 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst_n]

# HDMI TMDS clock pair.
set_property PACKAGE_PIN W16 [get_ports tmds_clk_p]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_p]
set_property PACKAGE_PIN Y16 [get_ports tmds_clk_n]
set_property IOSTANDARD TMDS_33 [get_ports tmds_clk_n]

# HDMI TMDS data pairs: channel index 0 maps to DATA0.
set_property PACKAGE_PIN AA17 [get_ports {tmds_data_p[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[0]}]
set_property PACKAGE_PIN AB17 [get_ports {tmds_data_n[0]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_n[0]}]

set_property PACKAGE_PIN U17 [get_ports {tmds_data_p[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[1]}]
set_property PACKAGE_PIN V17 [get_ports {tmds_data_n[1]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_n[1]}]

set_property PACKAGE_PIN U15 [get_ports {tmds_data_p[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_p[2]}]
set_property PACKAGE_PIN U16 [get_ports {tmds_data_n[2]}]
set_property IOSTANDARD TMDS_33 [get_ports {tmds_data_n[2]}]