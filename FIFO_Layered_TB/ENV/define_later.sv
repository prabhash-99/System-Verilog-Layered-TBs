
`ifndef FIFO_DRV_SV
`define FIFO_DRV_SV

`define WR_DRIV vif.wr_driver_dv
`define RD_DRIV vif.rd_driver_dv
class driver;

  transaction trans_h;

  mailbox #(transaction)g2d;

  virtual inf vif;
  event env_1,env_2;
//---------Connection Block------------------
  function void connect(mailbox#(transaction)g2d,virtual inf vif);
    this.g2d=g2d;
    this.vif=vif;
  endfunction



//---------------Run Task------------------

task run();
  forever  begin
  trans_h = new();
    g2d.get(trans_h);        //Getting DATA from the MailBOX
    $display("---------At Driver------------");
    trans_h.print_trans();
      
    fork
     
     begin
//------------------At Write Clock---------------------------
     // @(env_2);
     @(vif.wr_driver_dv); 
     //if(trans_h.property_1==WRITE || trans_h.property_1==WRITE_READ)begin
      write_entry(trans_h);
      -> env_1;
    //  end
     end

    begin
//------------------At Read Clock------------------------------
    // if(trans_h.property_1==READ||trans_h.property_1==WRITE_READ)begin
      wait(env_1.triggered); //@(env_1.triggered);

      @(vif.rd_driver_dv); 
      read_entry(trans_h);
     // ->env_2;
    //  end
      end
      
    join
    end
  endtask



  task write_entry(transaction trans_h);
    
    
      
      if(!vif.wr_rstn)begin
        $display("Write Reset Provided,time : %0t",$time);
        `WR_DRIV.wr_enb<='d0;
        `WR_DRIV.wr_data<='d0;
      wait(vif.wr_rstn);
        $display("Write Reset Ended,time  : %0t",$time);
      
      ->write_item_done;
      end
      else begin
     //WR_DRIV.wr_enb<=1'b0;


       // @(vif.wr_driver_dv); 
     //   if(trans_h.wr_enb)begin
        `WR_DRIV.wr_enb<=trans_h.wr_enb;
        
       // `WR_DRIV.rd_enb<=trans_h.rd_enb; //unable to access and
      //  synchronization of clock
        `WR_DRIV.wr_data<=trans_h.wr_data;
        


        //@(vif.wr_driver_dv);
       ->write_item_done;
      
       // end
      end

  endtask



  task read_entry(transaction trans_h);
    
    /*g2d.get(trans_h);        //Getting DATA from the MailBOX
    $display("---------At Driver------------");
    trans_h.print_trans();
    */


      if(!vif.rd_rstn)begin
        $display("Read Reset Provided,time : %0t",$time);
        `RD_DRIV.rd_enb<='d0;
      wait(vif.rd_rstn);
        $display("Read Reset Ended,time  : %0t",$time);
        
        //->read_item_done;
       ->write_item_done;
      end
      else begin
        `RD_DRIV.rd_enb<=1'b0;

      //  @(vif.rd_driver_dv)
        `RD_DRIV.rd_enb<=trans_h.rd_enb;
        //`RD_DRIV.wr_enb<=trans_h.wr_enb;
    
        
         //@(vif.rd_driver_dv)
        //->read_item_done;
       ->write_item_done;
        end


  endtask




endclass
`endif
