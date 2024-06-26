//This TESTCASE is basically to check if my Reset is working when it's
//assigned in between the packets
class test_9_extnd_in_between_reset extends generator;
  propert property_1;

  //Run PHASE
  virtual task run();
    write_cnt=0;
    read_cnt=0;


    repeat(2)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;
      
      super.put_trans();
      
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==READ;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      read_cnt++;
      
      super.put_trans();
    end

    ->reset_call;

    repeat(3)begin
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
