//This testcases is  basically performing WRITE READ operation parallely
class test_8_extnd_parallel extends generator;
  
  propert property_1;

  virtual task run();
    write_cnt=0;
    read_cnt=0;
    repeat(4)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;

      super.put_trans();
    end
    repeat(no_of_trans)begin
      trans_h=new();
      if(!trans_h.randomize() with  {property_1==WRITE_READ;})
        $error("Randomization Failed");
      $display("---------------At Generator Class-----------------");
      trans_h.print_trans();
      write_cnt++;
      read_cnt++;

      super.put_trans();
    end
  endtask
endclass
