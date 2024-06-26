`ifndef FIFO_SCRD_SV
`define FIFO_SCRD_SV
class scoreboard;

 // transaction trans_h_exp;
  transaction trans_h;

//  mailbox#(transaction)r2s;
	mailbox#(transaction)m2s;

//  Temporary Queue for Storing Write & Read DATA
  int write_temp_que [$];
  int read_temp_que [$];

//Temporary Regitser for Flag check
  bit temp_full_flag;
  bit temp_empty_flag;
  bit temp_overflow_flag;
  bit temp_underflow_flag;

//Temporary registers for poping out DATA
  int write_data;
  int read_data;

//Connect Phase
  function void connect(mailbox#(transaction)m2s);
	  this.m2s=m2s;
	endfunction
  
//Data Comparisiom Block
  task data_comparision_block ();
    forever begin
      wait (write_temp_que.size()!=0 && read_temp_que.size()!=0)begin
        write_data=write_temp_que.pop_front();
        read_data=read_temp_que.pop_front();
        
        //To Check Both Write Data & Read Data are equal
        if (write_data == read_data)begin
          $info("::::::Both WRITE & READ Data are same ::::: Write DATA-%0d,Read DATA-%0d::::::",write_data,read_data);
        end
        else begin
          $error(":::::Both WRITE & READ Data are different ::::: Write DATA-%0d,Read DATA-%0d::::::",write_data,read_data);
        end
      end
    end
  endtask
/*
//Flag Comparision Block
  task flag_comparision_block ();
    forever begin
      
      wait (write_temp_que.size() == 1'b0 || write_temp_que.size() == `DEPTH)begin
        if (temp_empty_flag == 0)begin
          $info ("Empty Flag is asserted and it's Working perfectly");
        end
        if (temp_full_flag == 1)begin
          $info ("Full Flag is asserted and it's Working perfectly");
        end
      end
    end
  endtask
*/

//Run Phase
  task run();
    fork 
    data_comparision_block ();
    forever begin
      m2s.get(trans_h);
      $display("-----------At ScoreBOARD(Original Value)------------");
      trans_h.print_trans();
      
      //When Reset is asserted then we delete Both the Queue
      if (trans_h.reset_flag)begin
        write_temp_que.delete();
        read_temp_que.delete();
      end

      //When Write Enable is asserted Pushing DATA to the Write Queue
      if(trans_h.wr_enb)begin
        write_temp_que.push_back(trans_h.wr_data);
      end

      //When Read Enable os asserted Pushing DATA to the Read Queue
      if (trans_h.rd_enb)begin
        read_temp_que.push_back(trans_h.rd_data);
      end

      //Asserting Full FLag & checking it's functionaing
      if (write_temp_que.size() == `DEPTH && read_temp_que.size() == 0)begin
        if (trans_h.full_flag == 1)begin
          $info ("::::::Full Flag is asserted and It's working completely Fine:::::");
        end
        else begin
          $error(":::::Full Flag didn't get asserted and it's not wroking properly:::::");
        end
      end

      //Asserting Empty FLag & checking it's functionaing
      if ( read_temp_que.size() == write_temp_que.size() )begin
        if (trans_h.empty_flag == 1)begin
          $info ("::::::Empty Flag is asserted and It's working completely Fine:::::");
        end
        else begin
          $error(":::::Empty Flag didn't get asserted and it's not wroking properly:::::");
        end
      end
/* TODO-UPDATA according to the designedr      
      //Asserting Almost Empty FLag & checking it's functionaing
      if ( read_temp_que.size() == write_temp_que.size() )begin
        if (trans_h.almost_empty_flag == 1)begin
          $info ("::::::Almost Empty Flag is asserted and It's working completely Fine:::::");
        end
        else begin
          $error(":::::Almost Empty Flag didn't get asserted and it's not wroking properly:::::");
        end
      end*/
/*  TODO-Update according to the Designer
      //Asserting Almost Full Flag & checking it's functionaing
      if ( read_temp_que.size() == write_temp_que.size() )begin
        if (trans_h.almost_full_flag == 1)begin
          $info ("::::::Almost Full Flag is asserted and It's working completely Fine:::::");
        end
        else begin
          $error(":::::Almost Full Flag didn't get asserted and it's not wroking properly:::::");
        end
      end*/
    end
    join
  endtask
endclass
`endif

/*
      if((trans_h.rd_data==trans_h_exp.rd_data) && (trans_h.rd_enb==1))begin
        $display("Values are TRUE : Original value  : %0d,Expected value:%0d",trans_h.rd_data,trans_h_exp.rd_data);
      end

      if((trans_h.full_flag==trans_h_exp.full_flag))begin
        $display("Full Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.full_flag,trans_h_exp.full_flag);
      end

      if((trans_h.empty_flag==trans_h_exp.empty_flag))begin
        $display("Empty Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.empty_flag,trans_h_exp.empty_flag);
      end

      if((trans_h.almost_empty_flag==trans_h_exp.almost_empty_flag))begin
        $display("Almost empty Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.almost_empty_flag,trans_h_exp.almost_empty_flag);
      end

      if((trans_h.almost_full_flag==trans_h_exp.almost_full_flag))begin
        $display("Almost full Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.almost_full_flag,trans_h_exp.almost_full_flag);
      end

      if((trans_h.overflow_flag==trans_h_exp.overflow_flag))begin
        $display("Overflow Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.overflow_flag,trans_h_exp.overflow_flag);
      end

      if((trans_h.underflow_flag==trans_h_exp.underflow_flag))begin
        $display("Underflow Flags Are at Same Status : Original_Flag value :%0d,Expcted_Flag value :%0d",trans_h.underflow_flag,trans_h_exp.underflow_flag);
      end
*/


















/*
  task run;
    forever begin
      
      wait(wr_m2s.num!=0 && rd_m2s.num!=0)    //Waiting till Both the MailBOXES gets filled and then go ahead with the Rest of Operation
        
        wr_trans_h  = new();
        wr_m2s.get(wr_trans_h);
        wr_trans_h_new  = new w r_m2s;
        $display("-------At Scoreboard Model(Original Values)(Write Handle)-------");
        wr_trans_h_new.print_trans();
        

        rd_trans_h  = new();
        rd_m2s.get(rd_trans_h);
        rd_trans_h_new  = new rd_m2s;
        $display("-------At Scoreboard Model(Original Values)(Read Handle)-------");
        rd_trans_h_new.print_trans();
        
        if(wr_trans_h_new.wr_enb)begin
          
          if(temp_memory.size==16)begin
            wr_trans_h_new_exp.full_flag=1'd1;

            if(wr_trans_h_new_exp.full_flag==wr_trans_h_new.full_flag)begin
              $display("Full Flag is Raised");
            end

          end
          else begin
            temp_memory.push_back(wr_trans_h_new.wr_data);
            
          end
        end


        if(rd_trans_h_new.rd_enb)begin
          
          if(temp_memory.size==0)begin
            rd_trans_h_new_exp.empty_flag=1'd1;

            if(rd_trans_h_new_exp.empty_flag==rd_trans_h_new.empty_flag)begin
              $display("EMPTY Flag is Raised");
            end
          end
          else begin
            rd_trans_h_new_exp.rd_data=temp_memory.pop_front();

            if(rd_trans_h_new_exp.rd_data==rd_trans_h.rd_data)begin
              $dislay("Values are Same  (Read DATA)  =>  Original Value  : %0d,Expected Value  : %0d",rd_trans_h_new.rd_data,rd_trans_h_new_exp.rd_data;
            end
          end
        end

  


      

    end
  endtask*/
