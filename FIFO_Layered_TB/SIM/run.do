vlib work
vlog -coveropt 3 +acc ../RTL/fifo.sv ../TEST/package_1.sv ../TOP/top.sv +incdir+../TEST +incdir+../ENV +incdir+../RTL
# vsim -voptargs=+acc +SANITY_CHECK work.top
# vsim -voptargs=+acc +BACK_2_BACK work.top
# vsim -voptargs=+acc +SIM_WR_RD work.top
# vsim -voptargs=+acc +FLAG_FULL work.top
# vsim -voptargs=+acc +FLAG_EMPTY work.top
# vsim -voptargs=+acc +FLAG_OVERFLOW work.top
# vsim -voptargs=+acc +PARALLEL work.top
 vsim -voptargs=+acc +IN_BETWEEN_RESET work.top
add wave -r /*
run -all
