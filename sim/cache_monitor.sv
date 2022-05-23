//`include "cache_transaction.sv"

`define MON_IF vif.monitor_cb
class cache_monitor;
  
  //creating virtual interface handle
  virtual cache_intf vif;
  
  //creating mailbox handle
  mailbox mon2scb; 
  //constructor
  function new(virtual cache_intf vif,mailbox mon2scb);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    forever begin
      cache_transaction trans;
      trans = new();

	wait(`MON_IF.cpu_req_valid); 
if(`MON_IF.cpu_req_rw) begin
		@(negedge vif.CLK);
		trans.cpu_req_addr = `MON_IF.cpu_req_addr; 
		trans.cpu_req_rw = `MON_IF.cpu_req_rw; 
		trans.cpu_req_datain = `MON_IF.cpu_req_datain;  
@(posedge vif.CLK);	      		
			end  
else begin	
		@(negedge vif.CLK);
		trans.cpu_req_addr = `MON_IF.cpu_req_addr; 
		trans.cpu_req_rw = `MON_IF.cpu_req_rw; 
		trans.cpu_req_datain = `MON_IF.cpu_req_datain;
  @(posedge vif.CLK)
 if (`MON_IF.state_mode == 1)  begin // HIT 
@(posedge vif.CLK); 
		trans.state_mode = `MON_IF.state_mode ;
		trans.cpu_req_dataout = `MON_IF.cpu_req_dataout; 
end
else if (`MON_IF.state_mode == 2 || `MON_IF.state_mode == 3) begin 
if (`MON_IF.state_mode == 2) begin //read clean
trans.state_mode = `MON_IF.state_mode ;
@(posedge vif.CLK); 
@(posedge vif.CLK);
trans.mem_req_datain =  `MON_IF.mem_req_datain ; 
@(posedge vif.CLK);
@(posedge vif.CLK);
trans.cpu_req_dataout = `MON_IF.cpu_req_dataout; 
end 
else if (`MON_IF.state_mode == 3) begin // read dirty
trans.state_mode = `MON_IF.state_mode ;
@(negedge `MON_IF.mem_req_valid)
		trans.mem_req_dataout = `MON_IF.mem_req_dataout; 
  @(posedge vif.CLK); 
  		@(negedge `MON_IF.mem_req_valid) 
@(posedge vif.CLK);
trans.mem_req_datain = `MON_IF.mem_req_datain; 
@(posedge vif.CLK);
@(posedge vif.CLK);
@(posedge vif.CLK);
@(negedge vif.CLK);
trans.cpu_req_dataout = `MON_IF.cpu_req_dataout;

end
end
end 

mon2scb.put(trans);

end	
  endtask
  
endclass
