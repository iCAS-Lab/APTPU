define_design_lib WORK -path "./work"

set TopDesign "systolic_array_top"

set_svf ./net/syn/${TopDesign}.svf

# -------------------------------------------------------------------------- #
# ----------------------------- RTL files List ----------------------------- #
# -------------------------------------------------------------------------- #
set RTL_files {\
        accurate_multiplier.v\
	Adder_Compensation.v\
	adder_RoBA.v\
	Adder.v\
	ALM_Gen_multiplication_unit.v\
	ALM_Gen_pre_approximate.v\
	ALM_LOA_top.v\
	ALM_MAA3_top.v\
	ALM_multiplication_unit.v\
	ALM_pre_approximate.v\
	ALM_SOA_top.v\
	ALM_top.v\
	Antilogarithmic_Converter.v\
	approx5_adder.v\
	approximate_adder_SA.v\
	approx_units_array.v\
	ASM_A_pre_approximate.v\
	ASM_B_pre_approximate.v\
	ASM_gen.v\
	ASM_multiplication_unit.v\
	ASM_pre_approximate.v\
	BAM_16x16.v\
	BAM_4x4.v\
	BAM_8x8.v\
	BAM_top.v\
	barrel_shifter.v\
	base2_mux.v\
	BLC.v\
	control_unit.v\
	decision_mux_Rounding.v\
	decision_mux.v\
	decoder.v\
	DR_ALM_multiplication_unit.v\
	DR_ALM_pre_approximate.v\
	DR_ALM_TOP.v\
	Dynamic_truncation.v\
	EIM16x16.v\
	EIM32x32.v\
	EIM4x4.v\
	EIM8x8.v\
	EIM.v\
	fifo_array.v\
	fifo.v\
	full_adder.v\
	Half_adder.v\
	heaa_adder.v\
	herloa_adder.v\
	hoaaned_adder.v\
	hoeraa_adder.v\
	LBC.v\
	ldca_adder.v\
	loa_adder.v\
	LOA.v\
	loawa_adder.v\
	LOD.v\
	Logarithmic_Converter.v\
	lzta_adder.v\
	MAA3.v\
	matrix.v\
	mheaa_adder.v\
	mherloa_adder.v\
	mitchell_multiplication_unit.v\
	mitchell_pre_approximate.v\
	mitchell.v\
	multiplication_unit.v\
	mux.v\
	oloca_adder.v\
	options_definitions.vh\
	P_Encoder.v\
	pe.v\
	power_k_mux.v\
	pre_comp_bank.v\
	RoBA_A_pre_approximate.v\
	RoBA_B_pre_approximate.v\
	RoBA_multiplication_unit.v\
	RoBA_top.v\
	Rounding_unit.v\
	row.v\
	select_unit.v\
	seta_adder.v\
	shared_approx_units.v\
	shifter.v\
	shift_left_mux.v\
	shift_unit.v\
	signed_product.v\
	SOA.v\
	subtractor.v\
	systolic_array_top.v\
	top_demux.v\
	top_mux.v\
	UDM_16x16.v\
	UDM_32x32.v\
	UDM_4x4.v\
	UDM_8x8.v\
	UDM_BB.v\
	UDM.v\
	unsign.v\
	Zero_Mux.v\
        }

#--------------------- Read and Analyze input RTL files
foreach design $RTL_files {
  analyze -format verilog ./net/rtl/${design}
}

elaborate ${TopDesign}

current_design ${TopDesign}

set_max_area 0

# -------------------------------------------------------------------------- #
# --------------------------- Design Constraints --------------------------- #
# -------------------------------------------------------------------------- #

reset_design

set auto_wire_load_selection true
set_wire_load_mode top

#Creating Clock
set clkPrd 10;
set clkPrd_h [expr {$clkPrd / 2}]; #Half Clock Period
set clkSkewSU [expr {$clkPrd * 0.02}]; #Clock Skew Setup

create_clock -period $clkPrd -name clk; #[get_ports clk]
set_clock_uncertainty -setup $clkSkewSU [get_clocks clk]

set_clock_latency -source -max [expr {$clkPrd*0.05}] [get_clocks clk]
set_clock_latency -max [expr {$clkPrd*0.05}] [get_clocks clk]


#Setting Input/Output Delay

set ALL_INP_EXC_CLK_RST [remove_from_collection [all_inputs] [get_ports "clk"]]
set ALL_INP_EXC_CLK_RST [remove_from_collection $ALL_INP_EXC_CLK_RST [get_ports "rst_n"]]


set_input_delay -max [expr {$clkPrd*0.35}] -clock [get_clocks clk] [all_inputs] 

set_output_delay -max [expr {$clkPrd*0.35}] -clock [get_clocks clk] [all_outputs]


#Setting Input/Output Design Rule Constraints

set MAX_INPUT_LOAD [expr {6 * [load_of NangateOpenCellLibrary/AND2_X1/A1]}]

set_max_capacitance $MAX_INPUT_LOAD [all_inputs]; #DC limits load on input ports

set_load -max [expr {4 * $MAX_INPUT_LOAD}] [all_outputs]; #DC set output port driving capability

set_input_transition -max 0.2 [all_inputs]; #specify transition times of input ports
#set_input_transition -max 0.2 $ALL_INP_EXC_CLK; #specify transition times of input ports

#set_driving cell specifies the input driving capabilities, as well as transition times
#if set_driving_cell has lower capability than set_max_capacitance, DC ignores set_max_cap..

set_driving_cell -lib_cell BUF_X1 -library NangateOpenCellLibrary [all_inputs];

# -------------------------------------------------------------------------- #
# -------------------------     Compile_first     -------------------------- #
# -------------------------------------------------------------------------- #

compile_ultra -no_autoungroup
puts "first iteration of compilation"
# -------------------------------------------------------------------------- #
# -------------------------    Compile-iterate2   -------------------------- #
# -------------------------------------------------------------------------- #
compile_ultra -no_autoungroup -incremental


# -------------------------------------------------------------------------- #
# ------------------------     Generate Reports     ------------------------ #
# -------------------------------------------------------------------------- #

report_constraint -all_violators

report_clock -attributes -skew  > ./reports/report_clock.txt
report_hierarchy                > ./reports/report_hier.txt
report_compile_options          > ./reports/report_option.txt
report_resources -hierarchy     > ./reports/report_resource.txt
report_port -verbose            > ./reports/report_port.txt
all_registers -level_sensitive  > ./reports/report_latches.txt
report_timing -loops            > ./reports/report_loops.txt
report_power                    > ./reports/report_power.txt

report_timing > reports/report_timing.txt

# maximum transition violation
report_constraint -all_violators -max_transition -nosplit -significant_digits 4 \
                                > ./reports/report_maxttransitions.txt

# maximum fanout violation
report_constraint -all_violators -max_fanout -nosplit -significant_digits 4 \
                                > ./reports/report_maxfanout.txt

# setup violation report
report_constraint -all_violators -max_delay -nosplit -significant_digits 4 \
                                > ./reports/report_vio_max_simple.txt

report_constraint -all_violators -max_delay -nosplit -significant_digits 4 -verbose \
                                > ./reports/report_vio_max_verbose.txt

report_area     > ./reports/report_area.txt

# -------------------------------------------------------------------------- #
# ------------------------     Generate Outputs     ------------------------ #
# -------------------------------------------------------------------------- #

current_design $TopDesign

define_name_rules verilog -remove_internal_net_bus -equal_ports_nets

change_names -rules verilog -hierarchy

#write_file -format ddc     -output $DdcFile  -hierarchy
write_file -format ddc     -output ./net/syn/$TopDesign.ddc  -hierarchy

write_file -format verilog -output ./net/syn/$TopDesign.syn.v -hierarchy

write_sdc net/syn/$TopDesign.sdc

write_sdf net/syn/$TopDesign.sdf

#


quit
