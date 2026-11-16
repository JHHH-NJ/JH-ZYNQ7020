# JH-ZYNQ7020-F V1.0 PL_CLK: 50 MHz on W17.
# Clock Wizard XCI supplies the related 50 MHz and 75 MHz generated clocks.
create_clock -period 20.000 -name SYS_CLK -waveform {0.000 10.000} -add [get_ports i_clk]
