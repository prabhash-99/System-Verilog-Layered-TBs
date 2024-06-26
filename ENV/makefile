regress: vlib vlog sim cover delete
vlib:
	vlib work
vlog:
	vlog -coveropt 3 +acc ../RTL/fifo.sv ../TEST/package_1.sv ../TOP/top.sv +incdir+../TEST +incdir+../ENV +incdir+../RTL
sim:
	vsim -voptargs=+acc -coverage top +SANITY_CHECK  -c -do "coverage save -onexit -directive -cvg -codeall test1.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +BACK_2_BACK_CHECK -c -do "coverage save -onexit -directive -cvg -codeall test2.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +SIM_WR_RD -c -do "coverage save -onexit -directive -cvg -codeall test3.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +FLAG_FULL -c -do "coverage save -onexit -directive -cvg -codeall test4.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +FLAG_EMPTY -c -do "coverage save -onexit -directive -cvg -codeall test5.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +PARALLEL -c -do "coverage save -onexit -directive -cvg -codeall test6.ucdb; run -all; exit"
	vsim -voptargs=+acc -coverage top +IN_BETWEEN_RESET -c -do "coverage save -onexit -directive -cvg -codeall test7.ucdb; run -all; exit"
cover:
	vcover merge fifo.ucdb test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb
delete:	 
	del test1.ucdb test2.ucdb test3.ucdb test4.ucdb test5.ucdb test6.ucdb test7.ucdb
	vcover report -details -html fifo.ucdb -htmldir FIFO_Report
 

