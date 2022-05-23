
`include "cache_transaction.sv"
`include "cache_generator.sv"
`include "cache_driver.sv"
`include "cache_monitor.sv"
`include "cache_scoreboard.sv"
class cache_environment;
  
  //generator and driver instance
  cache_generator  gen;
  cache_driver     driv;
  cache_monitor    mon;
  cache_scoreboard scb;
  
  //mailbox handle's
  mailbox gen2driv;
  mailbox mon2scb;
  
  //event for synchronization between generator and test
  event gen_ended;
  
  //virtual interface
  virtual cache_intf vif;
  
  
  //constructor
  function new(virtual cache_intf vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    gen2driv = new();
    mon2scb  = new();
    
    //creating generator and driver
    gen  = new(gen2driv,gen_ended);
    driv = new(vif,gen2driv);
    mon  = new(vif,mon2scb);
    scb  = new(mon2scb);
  endfunction
  
  //
  task pre_test();
    driv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    driv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
    #9999 $display("<---Files(Result-Cache_memory.mem and Result-main_memory.mem) Created Successfully--->");
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();

    $finish;
  endtask
  
endclass


