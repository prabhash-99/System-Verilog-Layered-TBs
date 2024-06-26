`ifndef FIFO_DRV_SV
`define FIFO_DRV_SV

`define WR_DRIV vif.wr_driver_dv
`define RD_DRIV vif.rd_driver_dv

class driver;
  // Transaction Class Handle
  transaction trans_h, wr_trans_h, rd_trans_h;

int cnt;
  // Mailbox
  mailbox #(transaction) g2d;

  // Virtual Interface
  virtual inf vif;

  // Queue of Transaction Class Type
  transaction write_temp_que[$];
  transaction read_temp_que[$];

  // Connect Phase
  function void connect(mailbox#(transaction) g2d, virtual inf vif);
    this.g2d = g2d;
    this.vif = vif;
  endfunction

  // Write Transaction -> Pin Level Activity
  task write_drive();
    $display("Write Drive Task Started,%0t",$time);
    forever@(vif.wr_driver_dv)begin
    // If Write enable is activated and the full flag is not asserted
    if (write_temp_que.size() != 0 && !`WR_DRIV.full_flag && vif.rstn) begin
      wr_trans_h = write_temp_que.pop_front();
      `WR_DRIV.wr_enb <= 1'b1;
      `WR_DRIV.wr_data <= wr_trans_h.wr_data;
      cnt++;
            $display(" write count %0d",cnt);
    end
    else begin
      `WR_DRIV.wr_enb <= 1'b0;
    end
    end
    $display("Write Drive Task Ended");

  endtask

  // Read Transaction -> Pin Level Activity
  task read_drive();
    $display("Read Drive Task Started,%0t",$time);
    forever@(vif.rd_driver_dv)begin
    // If Read enable is activated and the empty flag is not asserted
    if (read_temp_que.size() != 0 && `RD_DRIV.empty_flag && vif.rstn) begin
      rd_trans_h = read_temp_que.pop_front();
      //`RD_DRIV.rd_enb <= rd_trans_h.rd_enb;
      `RD_DRIV.rd_enb <= 1;
      cnt++;
       $display("read count %0d",cnt);
    end
    else begin
      `RD_DRIV.rd_enb <= 1'b0;
    end
    end
    $display("Read Drive Task Ended");
  endtask

  // Run Task
  task run();
  transaction trans1_h;
    forever begin
      if (!vif.rstn) begin  // Reset Task of Driver
        $display("----- Reset Has Started (Time: %0t) -----", $time);
        `WR_DRIV.wr_enb <= 'd0;
        `RD_DRIV.rd_enb <= 'd0;
        `WR_DRIV.wr_data <= 'd0;
        wait(vif.rstn);
        $display("----- Reset Has Ended (Time: %0t) -----", $time);
      end 
      else begin  // Normal Operation
        write_driver();
        read_drive();
        forever begin
          g2d.get(trans_h);
          $display("------ DRIVER ------");
          trans_h.print_trans();
          if (trans_h.wr_enb) begin
            write_temp_que.push_back(trans_h);
          end
          if (trans_h.rd_enb) begin
            read_temp_que.push_back(trans_h);
          end
        end
      end
    end
  endtask
endclass

  

//forevr
//  fork 
//  b: reset
//
//  b1: driver
//    forever
//      drive() Write n Read ()
//    begin
//  join_any
//  disable fork;
//

/*        
        
        fork
          write_drive();  // Write Transaction -> Pin Level Activity
          read_drive();  // Read Transaction -> Pin Level Activity
        join
        fork
          begin
          end
          begin
          end
        join_any
      end
    end
  endtask

endclass
*/
`endif
/*
              write_queue_push(trans_h);  // If Write Enable is there, pushing the data to the queue
              read_queue_push(trans_h);  // If Read Enable is there, pushing the data to the queue*/
 /*   forever begin
    fork
      begin
        reset();
      end
      
      begin : driving_logic
        forever begin
          write_drive();
          read_drive();
        end
    join_any
    disable diving_logic;
    end



*/
