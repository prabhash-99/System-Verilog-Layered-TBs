`ifndef FIFO_TOP_SV
`define FIFO_TOP_SV
`include "package_1.sv"
`include "define.sv"
`include "interface.sv"
module top;
  import pkg_1::*;
  
  bit wr_clk; //Write CLOCK
  bit rd_clk; //Read CLOCK

  inf interface_1(wr_clk,rd_clk); //Interface 
  test test_1;  //Test Class Handle

  async_fifo dut(.wr_clk(wr_clk),.rd_clk(rd_clk),.rstn(interface_1.rstn),.wr_en(interface_1.wr_enb),.rd_en(interface_1.rd_enb),.wr_data(interface_1.wr_data),.rd_data(interface_1.rd_data),.full(interface_1.full_flag),.empty(interface_1.empty_flag),.almost_empty(interface_1.almost_empty_flag),.almost_full(interface_1.almost_full_flag),.overflow(interface_1.overflow_flag),.underflow(interface_1.underflow_flag));

  //Task for Reset handling
  task reset();
    fork
      forever @(reset_call)begin
      interface_1.rstn=0; 
      #23  interface_1.rstn=1;
      end
    join_none
  endtask

  //Task for Initial Reset
  initial begin
    interface_1.rstn=0;
    #43  interface_1.rstn=1;
  end

  //All the Build & Connect Phase
  initial begin
			test_1=new();
      reset();//will track reset_call and whenever hitted will driver rst at pin level
      test_1.build();
      test_1.connect(interface_1);
      test_1.run();
      #500;
      $finish;
  end
  
  //Write Clock generation
  initial begin
    wr_clk=1'b0;
    forever #5 wr_clk=~wr_clk;
  end  //100MHz with 50% Duty Cycle

  //Read Clock generation
  initial begin
    rd_clk=1'b0;
    forever #10 rd_clk=~rd_clk;
  end //50MHz with 50% Duty Cycle

endmodule
`endif
