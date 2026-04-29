# -------------------------------------------------------------------------------------------------
# Copyright (C) 2023 Advanced Micro Devices, Inc
# SPDX-License-Identifier: MIT
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- --
# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Pin Assignments -- all other pins handled by board BSP
# -------------- -------------- -------------- -------------- -------------- -------------- -------
##
#set_property PACKAGE_PIN B10 [get_ports pl_sysref_p]
#set_property IOSTANDARD LVDS_25 [get_ports {pl_sysref*}]
set_property PACKAGE_PIN B10 [get_ports {pl_sysref_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_sysref_clk_p[0] pl_sysref_clk_n[0]}]

##
#set_property PACKAGE_PIN B8 [get_ports pl_clk_p]
#set_property IOSTANDARD LVDS_25 [get_ports {pl_clk*}]
set_property PACKAGE_PIN B8 [get_ports {pl_clk_clk_p[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {pl_clk_clk_p[0] pl_clk_clk_n[0]}]

##
set_property PACKAGE_PIN C11 [get_ports {clk104_clk_spi_mux_sel_tri_o[0]}]
set_property PACKAGE_PIN B12 [get_ports {clk104_clk_spi_mux_sel_tri_o[1]}]

set_property IOSTANDARD LVCMOS12 [get_ports {clk104_clk_spi_mux_sel_tri_o[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports {clk104_clk_spi_mux_sel_tri_o[1]}]


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
#create_clock -period 2.000 -name pl_clk [get_ports pl_clk_p]
create_clock -period 2.000 -name pl_clk [get_ports {pl_clk_clk_p[0]}]


## Input Delay for PL_SYSREF to ensure MTS requirements via PG269
#set_input_delay -clock [get_clocks pl_clk] -min -add_delay 2.000 [get_ports pl_sysref_p]
#set_input_delay -clock [get_clocks pl_clk] -max -add_delay 2.031 [get_ports pl_sysref_p]
set_input_delay -clock [get_clocks pl_clk] -min -add_delay 2.000 [get_ports {pl_sysref_clk_p[0]}]
set_input_delay -clock [get_clocks pl_clk] -max -add_delay 2.031 [get_ports {pl_sysref_clk_p[0]}]

set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets mts_i/clocktree/bufg_pl_clk/U0/BUFG_O[0]]


# -------------- -------------- -------------- -------------- -------------- -------------- -------
# Bitstream Generation
# -------------- -------------- -------------- -------------- -------------- -------------- -------
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
set_property BITSTREAM.CONFIG.USR_ACCESS TIMESTAMP [current_design]
