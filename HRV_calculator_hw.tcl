# TCL File Generated by Component Editor 18.1
# Tue Jan 11 16:24:36 CET 2022
# DO NOT MODIFY


# 
# HRV_calculator "HRV_calculator" v1.0
#  2022.01.11.16:24:36
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module HRV_calculator
# 
set_module_property DESCRIPTION ""
set_module_property NAME HRV_calculator
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME HRV_calculator
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL new_component
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file DE2_115.vhd VHDL PATH hrv_source/DE2_115.vhd TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 
