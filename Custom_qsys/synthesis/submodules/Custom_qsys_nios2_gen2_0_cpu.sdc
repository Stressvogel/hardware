# Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	Custom_qsys_nios2_gen2_0_cpu 	Custom_qsys_nios2_gen2_0_cpu:*
set 	Custom_qsys_nios2_gen2_0_cpu_oci 	Custom_qsys_nios2_gen2_0_cpu_nios2_oci:the_Custom_qsys_nios2_gen2_0_cpu_nios2_oci
set 	Custom_qsys_nios2_gen2_0_cpu_oci_break 	Custom_qsys_nios2_gen2_0_cpu_nios2_oci_break:the_Custom_qsys_nios2_gen2_0_cpu_nios2_oci_break
set 	Custom_qsys_nios2_gen2_0_cpu_ocimem 	Custom_qsys_nios2_gen2_0_cpu_nios2_ocimem:the_Custom_qsys_nios2_gen2_0_cpu_nios2_ocimem
set 	Custom_qsys_nios2_gen2_0_cpu_oci_debug 	Custom_qsys_nios2_gen2_0_cpu_nios2_oci_debug:the_Custom_qsys_nios2_gen2_0_cpu_nios2_oci_debug
set 	Custom_qsys_nios2_gen2_0_cpu_wrapper 	Custom_qsys_nios2_gen2_0_cpu_debug_slave_wrapper:the_Custom_qsys_nios2_gen2_0_cpu_debug_slave_wrapper
set 	Custom_qsys_nios2_gen2_0_cpu_jtag_tck 	Custom_qsys_nios2_gen2_0_cpu_debug_slave_tck:the_Custom_qsys_nios2_gen2_0_cpu_debug_slave_tck
set 	Custom_qsys_nios2_gen2_0_cpu_jtag_sysclk 	Custom_qsys_nios2_gen2_0_cpu_debug_slave_sysclk:the_Custom_qsys_nios2_gen2_0_cpu_debug_slave_sysclk
set 	Custom_qsys_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $Custom_qsys_nios2_gen2_0_cpu $Custom_qsys_nios2_gen2_0_cpu_oci]
set 	Custom_qsys_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $Custom_qsys_nios2_gen2_0_cpu_oci_path $Custom_qsys_nios2_gen2_0_cpu_oci_break]
set 	Custom_qsys_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $Custom_qsys_nios2_gen2_0_cpu_oci_path $Custom_qsys_nios2_gen2_0_cpu_ocimem]
set 	Custom_qsys_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $Custom_qsys_nios2_gen2_0_cpu_oci_path $Custom_qsys_nios2_gen2_0_cpu_oci_debug]
set 	Custom_qsys_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $Custom_qsys_nios2_gen2_0_cpu_oci_path $Custom_qsys_nios2_gen2_0_cpu_wrapper $Custom_qsys_nios2_gen2_0_cpu_jtag_tck]
set 	Custom_qsys_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $Custom_qsys_nios2_gen2_0_cpu_oci_path $Custom_qsys_nios2_gen2_0_cpu_wrapper $Custom_qsys_nios2_gen2_0_cpu_jtag_sysclk]
set 	Custom_qsys_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $Custom_qsys_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$Custom_qsys_nios2_gen2_0_cpu_jtag_sr*    -to *$Custom_qsys_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$Custom_qsys_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$Custom_qsys_nios2_gen2_0_cpu_oci_debug_path|monitor_go
