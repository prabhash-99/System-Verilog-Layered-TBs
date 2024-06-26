`ifndef FIFO_FUNC_COVG_SV
`define FIFO_FUNC_COVG_SV
class functional_coverage;
  virtual inf vif;
  mailbox#(transaction)m2func_covg;
  transaction trans_h;
  //Connect Phase
  function void connect (virtual inf vif,mailbox#(transaction)m2func_covg);
    this.vif=vif;
    this.m2func_covg=m2func_covg;
  endfunction
  //Covergroups for all the transitions of all the transition on FIFO  
  covergroup fifo_cv_grp;
    WR_ENABLE_TRANS : coverpoint trans_h.wr_enb {
      option.comment = "This Coverpoint is to basically check the transition of Write Enable";
      bins WR_ENB_0 = {0};
      bins WR_ENB_1 = {1};
      bins WR_ENB_0_1 = ( 0=>1, 1=>0 );
    }
    RD_ENABLE_TRANS : coverpoint trans_h.rd_enb {
      option.comment = "This Coverpoint is to basically check the transition of Write Enable";
      bins RD_ENB_0 = {0};
      bins RD_ENB_1 = {1};
      bins RD_ENB_0_1 = ( 0=>1, 1=>0 );
    }
    EMPTY_FLAG_TRANS : coverpoint trans_h.empty_flag {
      option.comment = "This Coverpoint is to basically check the transition of Empty Flag Transition";
      bins EMPTY_FLG_0 = {0};
      bins EMPTY_FLG_1 = {1};
      bins EMPTY_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    FULL_FLAG_TRANS : coverpoint trans_h.full_flag {
      option.comment = "This Coverpoint is to basically check the transition of Full Flag Transition";
      bins FULL_FLG_0 = {0};
      bins FULL_FLG_1 = {1};
      bins FULL_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    OVERFLOW_FLAG_TRANS : coverpoint trans_h.overflow_flag {
      option.comment = "This Coverpoint is to basically check the transition of Overflow Flag Transition";
      bins OVERFLOW_FLG_0 = {0};
      bins OVERFLOW_FLG_1 = {1};
      bins OVERFLOW_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    UNDERFLOW_FLAG : coverpoint trans_h.underflow_flag {
      option.comment = "This Coverpoint is to basically check the transition of Underflow Flag Transition";
      bins UNDERFLOW_FLG_0 = {0};
      bins UNDERFLOW_FLG_1 = {1};
      bins UNDERFLOW_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    ALMOST_FULL_FLAG_TRANS : coverpoint trans_h.almost_full_flag {
      option.comment = "This Coverpoint is to basically check the transition of Almost Full Flag Transition";
      bins ALMOST_FULL_FLG_0 = {0};
      bins ALMOST_FULL_FLG_1 = {1};
      bins ALMOST_FULL_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    ALMOST_EMPTY_FLAG_TRANS : coverpoint trans_h.empty_flag {
      option.comment = "This Coverpoint is to basically check the transition of Almost Empty Flag Transition";
      bins ALMOST_EMPTY_FLG_0 = {0};
      bins ALMOST_EMPTY_FLG_1 = {1};
      bins ALMOST_EMPTY_FLG_0_1 = (0 => 1, 1 => 0 );
    }
    WR_DATA_TRANS : coverpoint trans_h.wr_data {
      option.comment = "This Coverpoint is to basically check the Transition of WRITE DATA";
      bins WR_DATA_TRANS_LOW = { ['d0 : 'd100]};
      bins WR_DATA_TRANS_MEDIUM = { ['d100 : 'd200]};
      bins WR_DATA_TRANS_HIGH = { ['d200 : 'd255]};
    }
    RD_DATA_TRANS : coverpoint trans_h.rd_data {
      option.comment = "This Coverpoint is to basically check the Transition of READ DATA";
      bins RD_DATA_TRANS_LOW = { ['d0 : 'd100]};
      bins RD_DATA_TRANS_MEDIUM = { ['d100 : 'd200]};
      bins RD_DATA_TRANS_HIGH = { ['d200 : 'd255]};
    }
    RESET_TRANS : coverpoint trans_h.reset_flag {
      option.comment = "This Coverpoint is basically to check the transition of Reset";
      bins RESET_TRANS_0 = {0};
      bins RESET_TRANS_1 = {1};
      bins RESET_TRANS_0_1 = (0 => 1,1 => 0);
    }
    CROSS_WRITE_TRANS : cross WR_ENABLE_TRANS,WR_DATA_TRANS,FULL_FLAG_TRANS{
      option.comment = "This coverpoint is basically to check the Cross coverage of transition of Write Data Part";
      bins CROSS_WR_ENB = binsof (WR_ENABLE_TRANS.WR_ENB_1) &&
    /*  bins CROSS_WR_ENB =*/ binsof (FULL_FLAG_TRANS.FULL_FLG_1) ;
    }
    CROSS_READ_TRANS : cross RD_ENABLE_TRANS,RD_DATA_TRANS,EMPTY_FLAG_TRANS{
      option.comment = "This coverpoint is basically to check the Cross of Read Data Transition";
      bins CROSS_RD_ENB = binsof (RD_ENABLE_TRANS.RD_ENB_1) &&
     /* bins CROSS_RD_ENB =*/ binsof (EMPTY_FLAG_TRANS.EMPTY_FLG_1);
    }
  endgroup

    function new();
      fifo_cv_grp = new();
    endfunction

    //Run Phase
    task run();
      forever begin
        m2func_covg.get(trans_h);
        $display("-----At Functional Coverage Class-----");
        trans_h.print_trans();
        fifo_cv_grp.sample();
      end
    endtask
endclass
`endif
