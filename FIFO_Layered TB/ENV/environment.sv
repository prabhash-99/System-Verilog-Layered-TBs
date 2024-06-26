class environment;
  
  //Mailbox
  mailbox #(transaction) g2d;
	mailbox#(transaction)m2r;
	mailbox#(transaction)m2s;
	mailbox#(transaction)m2func_covg;

  //Handle for all the Environment Classes
	generator gen;
	driver driv;
	monitor mon;
	scoreboard scrd;
  functional_coverage func_covg;

  //Interface Handle
  virtual inf vif;

  //Build Phase
  function void build();
		g2d=new();
		m2r=new();
    m2s = new();
    m2func_covg = new();
    driv=new();
    mon=new();
    scrd=new();
    func_covg=new();
  endfunction

  //Connect Phase
  function void connect(virtual inf vif);
    this.vif=vif;
    gen.connect(g2d);
    $display("calling of env connect phase");
    driv.connect(g2d,vif);
    mon.connect(vif,m2s,m2func_covg);
    scrd.connect(m2s);
    func_covg.connect(vif,m2func_covg);
  endfunction

  //Run Phase
	task run(); 
    begin
		fork : fork_1
			gen.run();
			driv.run();
	    mon.run();
		  scrd.run();
      func_covg.run();
		join_none
    end
	endtask

endclass



