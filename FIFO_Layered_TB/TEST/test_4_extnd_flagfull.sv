//This TestCASES is basically to check if Full flag is getting asserted when
//FIFO is full and also when read happends if full flag gets deasserted

class test_4_extnd_flagfull extends generator;
  
  propert property_1;
  virtual task run();
    write_cnt=0;
    read_cnt=0;
    repeat(no_of_trans)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;
      super.put_trans();
    end
     repeat(2)begin
      trans_h=new();
      trans_h.wr_data.rand_mode(0);   //Did it to Stop Write DATA from randomizing
      if(!trans_h.randomize() with  {property_1==READ;  })
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      read_cnt++;
      super.put_trans();
    end
    repeat(2)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;
      super.put_trans();
    end
    
  endtask


endclass

