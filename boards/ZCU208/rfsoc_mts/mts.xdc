# ----------------------------------------------
# Copyright (C) 2023 Advanced Micro Devices, Inc
# ----------------------------------------------

# Differential PL_SYSREF and PL_CLK assignments
set_property PACKAGE_PIN B10 [get_ports {pl_sysref_clk_p[0]}]
set_property PACKAGE_PIN B9 [get_ports {pl_sysref_clk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_sysref_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_sysref_clk_n[0]}]

set_property PACKAGE_PIN B8 [get_ports {pl_clk_clk_p[0]}]
set_property PACKAGE_PIN B7 [get_ports {pl_clk_clk_n[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_clk_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_clk_clk_n[0]}]

# Synthesis guidance
set_property BLOCK_SYNTH.RETIMING 1 [get_cells {rfsoc_mts_i/rfdc/*}]
set_property BLOCK_SYNTH.STRATEGY {PERFORMANCE_OPTIMIZED} [get_cells {rfsoc_mts_i/rfdc/*}]
set_property BLOCK_SYNTH.RETIMING 1 [get_cells {rfsoc_mts_i/signal_capture/adc_*/axis_dwidth_converter/*}]
set_property BLOCK_SYNTH.STRATEGY {PERFORMANCE_OPTIMIZED} [get_cells {rfsoc_mts_i/signal_capture/adc_*/axis_dwidth_converter/*}]

# Timing constraints
create_clock -period 2.000 -name pl_clk [get_ports {pl_clk_clk_p[0]}]

set_input_delay -clock [get_clocks pl_clk] -min -add_delay 2.000 [get_ports {pl_sysref_clk_p[0]}]
set_input_delay -clock [get_clocks pl_clk] -max -add_delay 2.031 [get_ports {pl_sysref_clk_p[0]}]

set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets rfsoc_mts_i/sysref_capture/bufg_pl_clk/U0/BUFG_O[0]]

# Bitstream generation
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]