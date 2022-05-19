//`include "cache_transaction.sv"
class cache_generator;
  
  //declaring transaction class 
  rand cache_transaction trans,tr;
  
  //repeat count, to specify number of items to generate
  int  repeat_count;
  
  //mailbox, to generate and send the packet to driver
  mailbox gen2driv;
  
  
  
  //event
  event ended;
  
  //constructor
  function new(mailbox gen2driv,event ended);
    //getting the mailbox handle from env, in order to share the transaction packet between the generator and driver, the same mailbox is shared between both.
    this.gen2driv = gen2driv;
    this.ended    = ended;
    trans = new();
    
  endfunction
  
  //main task, generates(create and randomizes) the repeat_count number of transaction packets and puts into mailbox
  task main();
    randomise_values();
    //manual_values();
    
     -> ended; 
  endtask
  
  
  task manual_values();
	trans = new();
	trans.cpu_req_addr = 32'h6B00;
	trans.cpu_req_rw = 1;
	trans.cpu_req_datain = 128'h663322;
    	trans.display("[ Generator ]");
	gen2driv.put(trans);

	trans = new();
	trans.cpu_req_addr = 32'h6B00;
	trans.cpu_req_rw = 0;
    	trans.display("[ Generator ]");
	gen2driv.put(trans);
 
	trans = new();
	trans.cpu_req_addr = 32'hEB00;
	trans.cpu_req_rw = 0; 
    	trans.display("[ Generator ]");
   	gen2driv.put(trans);
    
 	trans = new();    
	trans.cpu_req_addr = 32'hDB00;
	trans.cpu_req_rw = 0;
    	trans.display("[ Generator ]");
	gen2driv.put(trans);
    
 	trans = new();    
	trans.cpu_req_addr = 32'hEE00;
	trans.cpu_req_rw = 0;
    	trans.display("[ Generator ]");
	gen2driv.put(trans);

 	trans = new();    
	trans.cpu_req_addr = 32'hEF00;
	trans.cpu_req_rw = 1;
	trans.cpu_req_datain = 128'hAABBCC;
    	//trans.display("[ Generator ]");
	//gen2driv.put(trans);

 	trans = new();    
	trans.cpu_req_addr = 32'h2F00;
	trans.cpu_req_rw = 0;
    	//trans.display("[ Generator ]");
	//gen2driv.put(trans);

  endtask
  
  
  

  task randomise_values();
    repeat(repeat_count) begin

    if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");

    tr = trans.do_copy();
    tr.display("[ Generator ]");

    gen2driv.put(tr) ;
    
    end
   
    
  endtask
  

  
  
  
  
  
  
endclass
