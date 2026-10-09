if {[version -short] ne "2025.2"} {error "Vivado 2025.2 required"}
cd [file dirname [file normalize [info script]]]
set overlay_name rfsoc-mts
open_project ${overlay_name}/${overlay_name}.xpr
set bd [get_files block_design.bd]
open_bd_design $bd
validate_bd_design
save_bd_design
generate_target all $bd
add_files -norecurse [make_wrapper -files $bd -top]
set_property top block_design_wrapper [current_fileset]
update_compile_order -fileset sources_1
reset_run synth_1
launch_runs synth_1 -jobs 6
wait_on_run synth_1
if {[get_property STATUS [get_runs synth_1]] ne "synth_design Complete!"} {error "Synthesis failed"}
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
if {[get_property STATUS [get_runs impl_1]] ne "write_bitstream Complete!"} {error "Bitstream generation failed"}
file mkdir bitstream
write_hw_platform -fixed -include_bit -force -file bitstream/mts.xsa
