//`include "cache_transaction.sv"

class cache_scoreboard;
   
  //creating mailbox handle
  mailbox mon2scb;
  
  //used to count the number of transactions
  int no_transactions;
    //array to use as local memory
  reg [31:0] mem[0:2**10-1];
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
	#100  
//------------------------------------------------------------
   if(trans.cpu_req_rw) begin 	
		mem[trans.cpu_req_addr[13:4]] = trans.cpu_req_datain; 		
			$display("@SCB: Write trans#(%0d) PASSED! [ tag=%18b, Index=%0d ] Req_Addr=%8h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4],trans.cpu_req_addr);
     	no_transactions++;	
	end
    else    begin
		//$display("@SCB: --------------------------------------------------"); 
			
		if ((trans.state_mode == 1)  && trans.cpu_req_dataout == mem[trans.cpu_req_addr[13:4]] ) begin  
			$display("@SCB: Read Hit trans#(%0d) PASSED! [tag=%18b, Index=%0d] Req_Addr=%8h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4],trans.cpu_req_addr); 
													end	
		else if(trans.state_mode == 2)       begin  mem[trans.cpu_req_addr[13:4]] = trans.mem_req_datain;   end
		else if(trans.state_mode == 3)  begin  mem[trans.cpu_req_addr[13:4]] = trans.mem_req_datain;   end

		if(trans.cpu_req_dataout == mem[trans.cpu_req_addr[13:4]]) begin
			if(trans.state_mode == 2)  begin  	
			$display("@SCB: Read Clean trans#(%0d) PASSED! [ tag=%18b, Index=%0d ] Req_Addr=%8h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4],trans.cpu_req_addr);   end
			else if(trans.state_mode == 3)  begin 	
			$display("@SCB: Read Dirty trans#(%0d) PASSED! 	[ tag=%18b, Index=%0d ] Req_Addr=%8h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4],trans.cpu_req_addr); end																end				
																		
		else begin
				$display("@SCB: Transfer trans#(%0d) FAILLED! 	[ tag=%18b, Index=%0d ] Req_Addr=%8h",no_transactions, trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4],trans.cpu_req_addr); 	
			end	
		no_transactions++;														
		end						
			
     
end  //forever end
  endtask
  
endclass
