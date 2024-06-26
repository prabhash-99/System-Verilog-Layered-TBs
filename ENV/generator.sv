`ifndef FIFO_GEN_SV
`define FIFO_GEN_SV
virtual class generator;
    
    protected transaction trans_h;
    virtual inf vif;

		local mailbox #(transaction)g2d;    //Mailbox for Generator to Driver
    
    //Connection of The MailBOX
    virtual function void connect(mailbox #(transaction) g2d);
      this.g2d=g2d;
      $display("COnnect of generator");
    endfunction

  //Task RUN
    pure virtual task run();

//--------Setting up this TASK which actually waits for the acknowledgement
//----------------from the WRITE clock ends-------------------
   protected task put_trans();
    g2d.put(trans_h);
    wait(write_cnt == write_drive_cnt && read_cnt == read_drive_cnt);
   endtask

endclass
`endif
/*
//--------Setting up this TASK which actually waits for the acknowledgement
//----------------from the READ clock ends-------------------
   protected task read_put_trans_and_wait_ack();
    g2d.put(trans_h);
    @(read_item_done);
   endtask
*/
