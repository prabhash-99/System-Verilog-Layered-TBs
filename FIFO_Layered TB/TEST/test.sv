class test;

  //All the Test Class handle  
  test_1_extnd_sanity test1;
  test_2_extnd_back2back test2;
  test_3_extnd_simultaneous test3;
  test_4_extnd_flagfull test4;
  test_5_extnd_flagempty test5;
//  test_6_extnd_underflowflag test6;
  test_7_extnd_overflowflag test7;
  test_8_extnd_parallel test8;
  test_9_extnd_in_between_reset test9;


  environment env=new();
  //Interface handle  
  virtual inf vif;
  
  //Build Phase
  virtual function void build();
    env.build();
  endfunction
  
  //Connect Phase
  virtual function void connect(virtual inf vif);
    //Test For Basic Sanity Check
    if($test$plusargs("SANITY_CHECK"))begin
      no_of_write_trans=1;
      no_of_read_trans=1;
      test1=new();
      env.gen=test1;
    end

    //Test to perform Consecutive Write->Read operation
    if($test$plusargs("BACK_2_BACK"))begin
      no_of_trans=6;
      test2=new();
      env.gen=test2;
    end
   
   //Basically Writing for n times & then afterward reading for n times
    if($test$plusargs("SIM_WR_RD"))begin
      no_of_write_trans=5;
      no_of_read_trans=5;
      test3=new();
      env.gen=test3;
    end

    //Test to check If Full FLag get's asserted
    if($test$plusargs("FLAG_FULL"))begin
      no_of_trans=16;
      test4=new();
      env.gen=test4;
    end

    //Test to check if EMpty Flag gets asserted
    if($test$plusargs("FLAG_EMPTY"))begin
      no_of_trans=3;
      test5=new();
      env.gen=test5;
    end
/*
    if($test$plusargs("FLAG_UNDERFLOW"))begin
      no_of_trans=3;
      test6=new();
      env.gen=test6;
    end
*/
    //Test to check If overflow FLag get's asserted
    if($test$plusargs("FLAG_OVERFLOW"))begin
      no_of_trans=22;
      test7=new();
      env.gen=test7;
    end

    //Trying to Perform both Write-Read operation parallely test
    if($test$plusargs("PARALLEL"))begin
      no_of_trans=6;
      test8=new();
      env.gen=test8;
    end
    
    //In between Reset test
    if($test$plusargs("IN_BETWEEN_RESET"))begin
      test9=new();
      env.gen=test9;
    end

    //Passing the Interface to the Environment
    env.connect(vif);
  endfunction

  //Run Phase
  task run();
    env.run();
  endtask

endclass
