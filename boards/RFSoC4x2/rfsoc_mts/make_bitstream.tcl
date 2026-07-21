set overlay_name "rfsoc_mts"
set design_name "block_design"
set xsa_name "mts"

open_project ./${overlay_name}/${overlay_name}.xpr

set bd_file \
    ./${overlay_name}/${overlay_name}.srcs/sources_1/bd/${design_name}/${design_name}.bd

open_bd_design $bd_file

set wrapper_file [make_wrapper -files [get_files $bd_file] -top]
add_files -norecurse $wrapper_file

set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

puts "Launching implementation and bitstream generation..."

launch_runs impl_1 -to_step write_bitstream -jobs 6
wait_on_run impl_1

set status [get_property STATUS [get_runs impl_1]]
puts "Implementation status: $status"

if {![string match "*Complete*" $status]} {
    error "Implementation did not complete successfully: $status"
}

file mkdir ./bitstream

write_hw_platform \
    -fixed \
    -include_bit \
    -force \
    -file ./bitstream/${xsa_name}.xsa

puts "Generated XSA: [file normalize ./bitstream/${xsa_name}.xsa]"