//This TESTCASE is to check the basic operation of the overflowflag if it's
//getting asserted
class test_7_extnd_overflowflag extends generator;
  
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
  endtask

endclass

