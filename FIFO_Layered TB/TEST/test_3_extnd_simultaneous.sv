//This TESTCASE is basicaaly first we are consecutive writing n times then we
//are reading n times
class test_3_extnd_simultaneous extends generator;
  
  propert property_1;
  virtual task run();
    write_cnt=0;
    read_cnt=0;

    repeat(no_of_write_trans)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;
      super.put_trans();
    end
    repeat(no_of_read_trans)begin
      trans_h=new();
      trans_h.wr_data.rand_mode(0);   //Did it to Stop Write DATA from randomizing
      if(!trans_h.randomize() with  {property_1==READ;  })
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      read_cnt++;
      super.put_trans();
    end
    
  endtask


endclass
