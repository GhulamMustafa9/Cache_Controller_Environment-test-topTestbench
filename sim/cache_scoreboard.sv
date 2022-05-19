//`include "cache_transaction.sv"

class cache_scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //used to count the number of transactions
  int no_transactions;
  
  //array to use as local memory
  
  //constructor
  function new(mailbox mon2scb);
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //stores wdata and compare rdata with stored data
  task main;
    cache_transaction trans;
    forever begin

      mon2scb.get(trans); 
#1000   
      if(trans.cpu_req_rw) begin 	
	$display("SCB: Write 	transaction(%0d) PASS! [tag=%0h, Index=%0h] Reduest_address=%0h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr);
        //trans.display("[ Scoreboard ]"); 
	no_transactions++;
	      
	end
      	else  begin
	$display("SCB: Read 	transaction(%0d) PASS! [tag=%0h, Index=%0h] Reduest_address=%0h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr);
       //trans.display("[ Scoreboard ]");
	no_transactions++; 
		end
     
end  //forever end
  endtask
  
endclass
