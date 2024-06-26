`ifndef FIFO_TRANS_SV
`define FIFO_TRANS_SV
typedef enum bit[1:0]{WRITE,READ,WRITE_READ}propert;//Based on which Feature to implement
  class transaction;
    rand bit wr_enb;
    rand bit rd_enb;
	  rand propert property_1;                            //The feature based in the Projecti
	  rand bit[`DATA_WIDTH-1:0] wr_data;   //The write dara
	  bit[`DATA_WIDTH-1:0]rd_data;         //The data read
    bit reset_flag; //Flag to check the assertion of the FLag
    bit full_flag;
    bit empty_flag;
    bit almost_empty_flag;
    bit almost_full_flag;
    bit overflow_flag;
    bit underflow_flag;
    
    //Constraint for Enum Write(Write Operation)
    constraint c1{
        if(property_1==WRITE){
          wr_enb==1;
          rd_enb==0;
        }
    }

    //Constraint for Enum Read(Read Operation)
    constraint c2{
        if(property_1==READ){
          rd_enb==1;
          wr_enb==0;
        }
    }

    //Constraint for Enum Write-Read(Both Write-Read taking place)
    constraint c3{
        if(property_1==WRITE_READ){
          wr_enb==1;
          rd_enb==1;
        }
    }

//-------Print task to print Values----------------
   	task print_trans();
		$display("-------------------transaction class-------------------");
		$display("Time\t|\tName\t\t|\tValue");
		$display("-------------------------------------------------------");
		$display("%0d\t|\tFunctionality\t\t|\t%0s", $time,property_1);
		$display("%0d\t|\twr_enbl\t\t|\t%0d", $time, wr_enb);
		$display("%0d\t|\trd_enbl\t\t|\t%0d", $time, rd_enb);
		$display("%0d\t|\twr_data\t\t|\t%0d", $time, wr_data);
		$display("%0d\t|\trd_data\t\t|\t%0d", $time, rd_data);
		$display("%0d\t|\tempty_flag\t\t|\t%0d", $time, empty_flag);
		$display("%0d\t|\tfull_flag\t\t|\t%0d", $time, full_flag);
		$display("%0d\t|\toverflow_flag\t\t|\t%0d", $time, overflow_flag);
		$display("%0d\t|\tunderflow_flag\t\t|\t%0d", $time, underflow_flag);
		$display("%0d\t|\talmost_empty_flag\t\t|\t%0d", $time, almost_empty_flag);
		$display("%0d\t|\talmost_full_flag\t\t|\t%0d", $time, almost_full_flag);
		$display("-------------------------------------------------------");
	endtask

	endclass
`endif












/*

  class write_transaction extends transaction;
    rand bit[ADDR_WIDTH-1:0]wr_addr;
    rand bit[DATA_WIDTH-1:0]wr_data;
    
    function void pre_randomize();
      wr_enb.rand_mode(0);
      rd_enb.rand_mode(0);
 //     wr_addr.rand_mode(0);
     // rd_addr.rand_mode(0);
      wr_enb=1;
      rd_enb=0;
    endfunction

endclass


  class read_transaction extends transaction;
   rand bit[ADDR_WIDTH-1:0]rd_addr;
   
   function void pre_randomize();
      wr_enb.rand_mode(0);
      rd_enb.rand_mode(0);
     // wr_addr.rand_mode(0);
     // rd_addr.rand_mode(0);
      wr_enb=0;
      rd_enb=1;
    endfunction

  endclass

  */
