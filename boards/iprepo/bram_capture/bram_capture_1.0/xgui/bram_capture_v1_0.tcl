# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "DATAWIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "MEM_SIZE_BYTES" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.DATAWIDTH { PARAM_VALUE.DATAWIDTH } {
	# Procedure called to update DATAWIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATAWIDTH { PARAM_VALUE.DATAWIDTH } {
	# Procedure called to validate DATAWIDTH
	return true
}

proc update_PARAM_VALUE.MEM_SIZE_BYTES { PARAM_VALUE.MEM_SIZE_BYTES } {
	# Procedure called to update MEM_SIZE_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_SIZE_BYTES { PARAM_VALUE.MEM_SIZE_BYTES } {
	# Procedure called to validate MEM_SIZE_BYTES
	return true
}


proc update_MODELPARAM_VALUE.DATAWIDTH { MODELPARAM_VALUE.DATAWIDTH PARAM_VALUE.DATAWIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATAWIDTH}] ${MODELPARAM_VALUE.DATAWIDTH}
}

proc update_MODELPARAM_VALUE.MEM_SIZE_BYTES { MODELPARAM_VALUE.MEM_SIZE_BYTES PARAM_VALUE.MEM_SIZE_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_SIZE_BYTES}] ${MODELPARAM_VALUE.MEM_SIZE_BYTES}
}

