create_clock -period 20.000 -name SYS_CLK -waveform {0.000 10.000} -add [get_ports sys_clk]
create_clock -period 8.000 -name eth_rxc -waveform {0.000 4.000} [get_ports eth_rxc]


set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets gmii_rx_clk]
