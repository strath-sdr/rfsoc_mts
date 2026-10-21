# Check Vivado version and set project names.
if {[version -short] ne "2025.2"} {
    error "Vivado 2025.2 required"
}

cd [file dirname [file normalize [info script]]]
set overlay_name rfsoc-mts
set project_name block_design
set design_name rfsoc_mts

# Open and validate the block design.
open_project ${project_name}/${project_name}.xpr
set bd [get_files ${design_name}.bd]
open_bd_design $bd
validate_bd_design
save_bd_design

# Generate IP output products and the HDL wrapper.
generate_target all $bd
add_files -norecurse [make_wrapper -files $bd -top]
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

# Run synthesis and check completion.
reset_run synth_1
launch_runs synth_1 -jobs 6
wait_on_run synth_1

if {[get_property STATUS [get_runs synth_1]] ne "synth_design Complete!"} {
    error "Synthesis failed"
}

# Run implementation through bitstream generation.
launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1
if {[get_property STATUS [get_runs impl_1]] ne "write_bitstream Complete!"} {
    error "Bitstream generation failed"
}

# Export the hardware platform with the bitstream.
# TODO: remove bitstream directory and add .xsa, .bit, .hwh to the .gitignore
file mkdir bitstream
write_hw_platform -fixed -include_bit -force -file bitstream/mts.xsa
