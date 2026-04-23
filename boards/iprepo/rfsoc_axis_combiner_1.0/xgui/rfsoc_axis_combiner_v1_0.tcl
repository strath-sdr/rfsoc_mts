# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_ENABLE_M00_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M02_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M10_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M12_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M20_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M22_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M30_AXIS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_ENABLE_M32_AXIS" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_ENABLE_M00_AXIS { PARAM_VALUE.C_ENABLE_M00_AXIS } {
	# Procedure called to update C_ENABLE_M00_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M00_AXIS { PARAM_VALUE.C_ENABLE_M00_AXIS } {
	# Procedure called to validate C_ENABLE_M00_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M02_AXIS { PARAM_VALUE.C_ENABLE_M02_AXIS } {
	# Procedure called to update C_ENABLE_M02_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M02_AXIS { PARAM_VALUE.C_ENABLE_M02_AXIS } {
	# Procedure called to validate C_ENABLE_M02_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M10_AXIS { PARAM_VALUE.C_ENABLE_M10_AXIS } {
	# Procedure called to update C_ENABLE_M10_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M10_AXIS { PARAM_VALUE.C_ENABLE_M10_AXIS } {
	# Procedure called to validate C_ENABLE_M10_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M12_AXIS { PARAM_VALUE.C_ENABLE_M12_AXIS } {
	# Procedure called to update C_ENABLE_M12_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M12_AXIS { PARAM_VALUE.C_ENABLE_M12_AXIS } {
	# Procedure called to validate C_ENABLE_M12_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M20_AXIS { PARAM_VALUE.C_ENABLE_M20_AXIS } {
	# Procedure called to update C_ENABLE_M20_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M20_AXIS { PARAM_VALUE.C_ENABLE_M20_AXIS } {
	# Procedure called to validate C_ENABLE_M20_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M22_AXIS { PARAM_VALUE.C_ENABLE_M22_AXIS } {
	# Procedure called to update C_ENABLE_M22_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M22_AXIS { PARAM_VALUE.C_ENABLE_M22_AXIS } {
	# Procedure called to validate C_ENABLE_M22_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M30_AXIS { PARAM_VALUE.C_ENABLE_M30_AXIS } {
	# Procedure called to update C_ENABLE_M30_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M30_AXIS { PARAM_VALUE.C_ENABLE_M30_AXIS } {
	# Procedure called to validate C_ENABLE_M30_AXIS
	return true
}

proc update_PARAM_VALUE.C_ENABLE_M32_AXIS { PARAM_VALUE.C_ENABLE_M32_AXIS } {
	# Procedure called to update C_ENABLE_M32_AXIS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ENABLE_M32_AXIS { PARAM_VALUE.C_ENABLE_M32_AXIS } {
	# Procedure called to validate C_ENABLE_M32_AXIS
	return true
}

proc update_PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S02_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S02_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S10_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S10_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S12_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S12_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S20_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S20_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S22_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S22_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S30_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S30_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S32_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S32_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S02_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S02_AXIS_TDATA_WIDTH PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S02_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S02_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S10_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S10_AXIS_TDATA_WIDTH PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S10_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S10_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S12_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S12_AXIS_TDATA_WIDTH PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S12_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S12_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S20_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S20_AXIS_TDATA_WIDTH PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S20_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S20_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S22_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S22_AXIS_TDATA_WIDTH PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S22_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S22_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S30_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S30_AXIS_TDATA_WIDTH PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S30_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S30_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S32_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S32_AXIS_TDATA_WIDTH PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S32_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S32_AXIS_TDATA_WIDTH}
}

