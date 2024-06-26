
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
    $display("Write Drive Task Started");
    @(vif.wr_driver_dv);
    if (write_temp_que.size() != 0 && !`WR_DRIV.full_flag && vif.rstn) begin
      `WR_DRIV.wr_enb <= 1'b1;
      wr_trans_h = write_temp_que.pop_front();
      `WR_DRIV.wr_data <= wr_trans_h.wr_data;
    end else begin
      `WR_DRIV.wr_enb <= 1'b0;
    end
    $display("Write Drive Task Ended");
  endtask

  // Read Transaction -> Pin Level Activity
  task read_drive();
    $display("Read Drive Task Started");
    @(vif.rd_driver_dv);
    if (read_temp_que.size() != 0 && !`RD_DRIV.empty_flag && vif.rstn) begin
      rd_trans_h = read_temp_que.pop_front();
      `RD_DRIV.rd_enb <= rd_trans_h.rd_enb;
    end else begin
      `RD_DRIV.rd_enb <= 1'b0;
    end
    $display("Read Drive Task Ended");
  endtask

  // Task for Pushing Write Transaction to the Queue
  task write_queue_push();
    $display("Task write_queue_push Started");
    if (trans_h.wr_enb) begin
      write_temp_que.push_back(trans_h);
    end
    $display("Task write_queue_push Ended");
  endtask

  // Task for Pushing Read Transaction to the Queue
  task read_queue_push();
    $display("Task read_queue_push Started");
    if (trans_h.rd_enb) begin
      read_temp_que.push_back(trans_h);
    end
    $display("Task read_queue_push Ended");
  endtask

  // Run Task
  task run();
    forever begin
      if (!vif.rstn) begin
        $display("----- Reset Has Started (Time: %0t) -----", $time);
        `WR_DRIV.wr_enb <= 0;
        `RD_DRIV.rd_enb <= 0;
        `WR_DRIV.wr_data <= 0;
        wait(vif.rstn);
        $display("----- Reset Has Ended (Time: %0t) -----", $time);
      end else begin
        g2d.get(trans_h);
        $display("------- DRIVER --------");
        trans_h.print_trans();

        fork
          write_queue_push();
          write_drive();
          read_queue_push();
          read_drive();
        join
      end
    end
  endtask

endclass

`endif
