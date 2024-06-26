package pkg_1;
  
  
  event reset_call;
  int no_of_trans;
  int no_of_write_trans;
  int no_of_read_trans;
  int write_cnt;
  int write_drive_cnt;
  int read_cnt;
  int read_drive_cnt;

  `include "define.sv"
	`include "transaction.sv"
	`include "generator.sv"
	`include "driver.sv"
	`include "monitor.sv"
	`include "scoreboard.sv"
	`include "functional_coverage.sv"
	`include "environment.sv"

  `include "test_1_extnd_sanity.sv"
  `include "test_2_extnd_back2back.sv"
  `include "test_3_extnd_simultaneous.sv"
  `include "test_4_extnd_flagfull.sv"
  `include "test_5_extnd_emptyflag.sv"
  //`include "test_6_extnd_underflowflag.sv"
  `include "test_7_extnd_overflowflag.sv"
  `include "test_8_extnd_parallel.sv"
  `include "test_9_extnd_in_between_reset.sv"

//----------TestFILES-------------------
	`include "test.sv"


endpackage
