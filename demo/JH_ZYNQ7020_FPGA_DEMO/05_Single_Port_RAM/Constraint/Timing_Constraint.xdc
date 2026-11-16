# JH-ZYNQ7020-F V1.0 PL_CLK: 50 MHz on W17.
create_clock -period 20.000 -name SYS_CLK -waveform {0.000 10.000} [get_ports i_clk]
