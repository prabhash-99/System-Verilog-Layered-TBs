`ifndef FIFO_DRV_SV
`define FIFO_DRV_SV
`define WR_DRIV vif.wr_driver_dv
`define RD_DRIV vif.rd_driver_dv
class driver;

  // Transaction Class Handle
  transaction trans_h, wr_trans_h, rd_trans_h;
 
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
        if (write_temp_que.size() != 0 && !`WR_DRIV.full_flag && vif.rstn) begin
          wr_trans_h = write_temp_que.pop_front();
          `WR_DRIV.wr_enb <= 1'b1;
          `WR_DRIV.wr_data <= wr_trans_h.wr_data;
          write_drive_cnt++;
        end
        else begin
          `WR_DRIV.wr_enb <= 1'b0;
        end
      end
      //Reset handling Task
      if(!vif.rstn) begin //If it dectect ACTIVE-LOW Reset it will immediately come out of the TASK
          return ;
        end

      $display("Write Drive Task Ended");
  endtask
 
  // Read Transaction -> Pin Level Activity
  task read_drive();
    $display("Read Drive Task Started,%0t",$time);
      forever@(vif.rd_driver_dv)begin
        if (read_temp_que.size() != 0 && !(`RD_DRIV.empty_flag) && vif.rstn) begin
          `RD_DRIV.rd_enb <= 1;
          rd_trans_h = read_temp_que.pop_front();
          $display("Welcome to Read Drive task");
        end
        else begin
          `RD_DRIV.rd_enb <= 1'b0;
        end
       end
       //Reset handling Task
       if(!vif.rstn) begin  //If it dectect ACTIVE-LOW Reset it will immediately come out of the TASK
         return ;
        end
    $display("Read Drive Task Ended");
  endtask

  //Reset Task
  task reset();
    $display("----- Reset Has Started (Time: %0t) -----", $time);
      `WR_DRIV.wr_enb <= 'd0;
      `RD_DRIV.rd_enb <= 'd0;
      `WR_DRIV.wr_data <= 'd0;
    $display("----- Reset Has Ended (Time: %0t) -----", $time);
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
       fork  
        write_drive();  
        read_drive();
        forever begin // { 
          if(!vif.rstn) begin
            break;
          end
          else begin
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
        end // } forever end
      join_any
      reset();  //RESET Task Enable
     end
    end
  endtask

endclass
`endif
