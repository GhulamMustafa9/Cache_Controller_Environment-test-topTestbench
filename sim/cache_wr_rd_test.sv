
`include "cache_environment.sv"
program cache_test(cache_intf intf);
  
  class my_trans extends cache_transaction;      
    //function void pre_randomize();
    //endfunction    
  endclass   
  //declaring environment instance
  cache_environment env;
  my_trans my_tr;
  
  initial begin
    //creating environment
    env = new(intf); 
    my_tr = new();
    //setting the repeat count of generator as 4, means to generate 4 packets
    env.gen.repeat_count = 10;
    env.gen.trans = my_tr;
    //calling run of env, it interns calls generator and driver main tasks.
    env.run();
  end
endprogram
