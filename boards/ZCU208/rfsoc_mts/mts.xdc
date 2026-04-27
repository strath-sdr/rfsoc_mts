# -------------------------------------------------------------------------------------------------
# Copyright (C) 2023 Advanced Micro Devices, Inc
# SPDX-License-Identifier: MIT
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Pin Assignments -- all other pins handled by board BSP
# -------------- -------------- -------------- -------------- -------------- -------------- -------
set_property PACKAGE_PIN AP18 [get_ports pl_sysref_p]
set_property PACKAGE_PIN AR18 [get_ports pl_sysref_n]

set_property IOSTANDARD LVDS [get_ports {pl_sysref_p}]
set_property IOSTANDARD LVDS [get_ports {pl_sysref_n}]

set_property PACKAGE_PIN AN11 [get_ports pl_clk_p]
set_property PACKAGE_PIN AP11 [get_ports pl_clk_n]

set_property IOSTANDARD LVDS [get_ports {pl_clk_p}]
set_property IOSTANDARD LVDS [get_ports {pl_clk_n}]


# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Synthesis Guidance
# -------------- -------------- -------------- -------------- -------------- -------------- -------

set_property BLOCK_SYNTH.RETIMING 1 [get_cells {mts_i/rfdc/*}]
set_property BLOCK_SYNTH.STRATEGY {PERFORMANCE_OPTIMIZED} [get_cells {mts_i/rfdc/*}]
set_property BLOCK_SYNTH.RETIMING 1 [get_cells {mts_i/signal_capture/adc_*/axis_dwidth_converter/*}]
set_property BLOCK_SYNTH.STRATEGY {PERFORMANCE_OPTIMIZED} [get_cells {mts_i/signal_capture/adc_*/axis_dwidth_converter/*}]

# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Timing Constraints
# -------------- -------------- -------------- -------------- -------------- -------------- -------
create_clock -period 2.000 -name pl_clk [get_ports pl_clk_p]

#set_input_delay -clock [get_clocks pl_clk] -min 2.000 [get_ports {pl_sysref_*}]
#set_input_delay -clock [get_clocks pl_clk] -max 2.300 [get_ports {pl_sysref_*}]


## Input Delay for PL_SYSREF to ensure MTS requirements via PG269
set_input_delay -clock [get_clocks pl_clk] -min -add_delay 2.000 [get_ports pl_sysref_p]
set_input_delay -clock [get_clocks pl_clk] -max -add_delay 2.031 [get_ports pl_sysref_p]


set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets mts_i/clocktree/bufg_pl_clk/U0/BUFG_O[0]]

#set_false_path -from [get_ports reset]
#set_false_path -from [get_pins {mts_i/clocktree/aresetn_250M/U0/ACTIVE_LOW_PR_OUT_DFF[*].*/C}]

# Constrain the user_sysref clocks
#set_max_delay -from [get_pins {mts_i/clocktree/synch_sysref/inst/xsingle/syncstages_ff_reg[1]/C}] 1.0
#set_max_delay -from [get_pins {mts_i/clocktree/synch_sysref/inst/xsingle/src_ff_reg/C}] 1.0

# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Debug / Chipscope
# -------------- -------------- -------------- -------------- -------------- -------------- -------
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk]

# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Bitstream Generation
# -------------- -------------- -------------- -------------- -------------- -------------- -------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
