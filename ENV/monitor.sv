`ifndef FIFO_MON_SV
`define FIFO_MON_SV
`define WR_MTR vif.wr_monitor_mtr
`define RD_MTR vif.rd_monitor_mtr
class monitor;

  transaction trans_h;  //Instanciating the Transaction Handle
  mailbox#(transaction)m2s;//MailBOX  from monitor to Reference Model
  mailbox#(transaction)m2func_covg;//MailBOX  from monitor to Functional Coverage Class
  virtual inf vif;        //Interface Instaciating
  
  //Connection Phase
  function void connect(virtual inf vif,mailbox#(transaction)m2s,mailbox#(transaction)m2func_covg);
	  this.vif=vif;
    this.m2s=m2s;
    this.m2func_covg=m2func_covg;
  endfunction	

  //Run Phase
  task run();
    forever begin
   /*   if (!vif.rstn)begin
        trans_h=new();
        trans_h.reset_flag=1'b1;
        $display("---------At Monitor(RESET)---------");
        trans_h.print_trans();
        m2s.put(trans_h);
      end
      else begin*/
 /*      if(!vif.rstn)begin
        trans_h=new();
        trans_h.reset_flag = 1'b1;
        trans_h.wr_enb=vif.wr_enb;
        trans_h.wr_data=vif.wr_data;
        trans_h.full_flag=vif.full_flag;
        trans_h.almost_full_flag=vif.almost_full_flag;
        trans_h.overflow_flag=vif.overflow_flag;
        trans_h.rd_enb=vif.rd_enb;
        trans_h.empty_flag=vif.empty_flag;
        trans_h.rd_data=vif.rd_data;
        trans_h.almost_empty_flag=vif.almost_empty_flag;
        trans_h.underflow_flag=vif.underflow_flag;
        $display("---------At Monitor(RESET CONDITION)---------");
        trans_h.print_trans();
        m2s.put(trans_h);
      end
     / else begin*/
       fork
          reset_process();  //task for handling the RESET condition
          write_clock_process();
          read_clock_process();
        join
    // end
end
  endtask

  //Reset Process
  task reset_process();
    forever @(!vif.rstn)begin
       trans_h=new();
       trans_h.reset_flag = 1'b1;
       trans_h.wr_enb=vif.wr_enb;
       trans_h.wr_data=vif.wr_data;
       trans_h.full_flag=vif.full_flag;
       trans_h.almost_full_flag=vif.almost_full_flag;
       trans_h.overflow_flag=vif.overflow_flag;
       trans_h.rd_enb=vif.rd_enb;
       trans_h.empty_flag=vif.empty_flag;
       trans_h.rd_data=vif.rd_data;
       trans_h.almost_empty_flag=vif.almost_empty_flag;
       trans_h.underflow_flag=vif.underflow_flag;
       $display("---------At Monitor(RESET CONDITION)---------");
       trans_h.print_trans();
       m2s.put(trans_h);
       m2func_covg.put(trans_h);
    end
  endtask

  //Write Clock Process
  task write_clock_process;
    forever@(vif.wr_monitor_mtr)begin
      if(`WR_MTR.wr_enb && vif.rstn)begin
          trans_h=new();
          trans_h.property_1=WRITE;//TODO change into gneric mode
          trans_h.wr_enb=`WR_MTR.wr_enb;
          trans_h.wr_data=`WR_MTR.wr_data;
          $display("Write DATA sampling,%0d,Inf->%0d,%0t",trans_h.wr_data,`WR_MTR.wr_data,$time);
          trans_h.reset_flag=1'b0;
          trans_h.full_flag=`WR_MTR.full_flag;
          trans_h.almost_full_flag=`WR_MTR.almost_full_flag;
          trans_h.overflow_flag=`WR_MTR.overflow_flag;
          $display("---------At Monitor(WRITE)---------");
          trans_h.print_trans();
          m2s.put(trans_h);
          m2func_covg.put(trans_h);
      end
    end
  endtask

  //Read Clock Process
  task read_clock_process;
    forever@(vif.rd_monitor_mtr )begin
      if(`RD_MTR.rd_enb && vif.rstn)begin
          read_drive_cnt++;
          trans_h=new();
          trans_h.property_1=READ;//TODO change into generic mode
          trans_h.rd_enb=`RD_MTR.rd_enb;
          trans_h.rd_data=`RD_MTR.rd_data;
          trans_h.empty_flag=1'b0;
          trans_h.almost_empty_flag=`RD_MTR.almost_empty_flag;
          trans_h.underflow_flag=`RD_MTR.underflow_flag;
          $display("---------At Monitor(READ)---------");
          trans_h.print_trans();
          m2s.put(trans_h);
          m2func_covg.put(trans_h);
      end
    end
  endtask

endclass
`endif


