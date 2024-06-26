//////////////////////////////
//  
//  TOPIC : Verification of FIFO
//    File name:interface.sv
//    Date:09/05/2024
//    
//
//COMPONENT : Interface
///////////////////////////////
interface inf(input logic wr_clk,input logic rd_clk);

  logic wr_enb;
  logic rd_enb;
  logic rstn;
  logic[`DATA_WIDTH-1  : 0] wr_data;
  logic[`DATA_WIDTH-1  : 0] rd_data;
  logic full_flag;
  logic empty_flag;
  logic almost_empty_flag;
  logic almost_full_flag;
  logic overflow_flag;
  logic underflow_flag;
  
  
  clocking wr_driver_dv@(posedge wr_clk);
    default input #0 output #1;
    output wr_enb;
    output wr_data;
    input full_flag;
  endclocking

  clocking rd_driver_dv@(posedge rd_clk);
    default input #0 output #1;
    output rd_enb;
    input empty_flag;
  endclocking

  clocking wr_monitor_mtr@(posedge wr_clk);
    default input #0 output #1 ;
    input wr_enb;
    input wr_data;
    input full_flag;
    input almost_full_flag;
    input overflow_flag;
  endclocking

  clocking rd_monitor_mtr@(posedge rd_clk);
    default input #0 output #1 ;
    input rd_enb;
    input rd_data;
    input empty_flag;
    input almost_empty_flag;
    input underflow_flag;
  endclocking


  modport WRITE_DRIVER(clocking wr_driver_dv,input wr_clk);
  modport READ_DRIVER(clocking rd_driver_dv,input rd_clk);
  modport WRITE_MONITOR(clocking wr_monitor_mtr,input wr_clk);
  modport READ_MONITOR(clocking rd_monitor_mtr,input rd_clk);
  
//::::::::::::::::::::ASSERTIONS::::::::::::::::::::::::::::: 
  default disable iff (!rstn);
  //Basically this assertion is for when Full Flag is High at that very next
  //clock cycle Write Shouldn't take place
  property full_condition_check; 
    @(posedge wr_clk) full_flag |=> !($rose(wr_enb)); 
  endproperty

  //Basically this assertion is based on whenever Empty Flag is asserted at
  //the very read next cycle Read shouldn't take place
  property empty_condition_check;
    @(posedge rd_clk) empty_flag |=> !($rose(rd_enb));
  endproperty

  //Basically this assertion is for the RESET Condition Check
  property reset_check;
    @(posedge wr_clk or posedge rd_clk) disable iff(rstn)
      (!rstn) |-> $fell(full_flag) && $rose(empty_flag) && $fell(overflow_flag) && $fell(underflow_flag) && $fell(almost_empty_flag) && $fell(almost_full_flag);
  endproperty
endinterface
  


/*
  //Basically this condition is whenever the Almost full Flag get's asserted
  //than after certain period the full flag needs to gets asserted
  sequence almost_full_condition
    $rose(almost_full_flag) && [*]
  endsequence

  property almost_full_flag_check;
    @(posedge wr_clk) $rose(almost_full_flag) |-> ##T $rose(full_flag); 
  endproperty*/
