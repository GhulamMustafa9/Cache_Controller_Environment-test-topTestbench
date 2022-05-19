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

	wait(`MON_IF.cpu_req_valid)
      if(`MON_IF.cpu_req_valid) begin
        //$display ("Monitor tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  mem-addr=%0d(h%6h)(b%0b)  Read",  `MON_IF.cpu_req_addr[31:14], `MON_IF.cpu_req_addr[31:14], `MON_IF.cpu_req_addr[13:4], `MON_IF.cpu_req_addr[13:4], `MON_IF.cpu_req_addr[3:0], `MON_IF.cpu_req_addr[3:0], `MON_IF.cpu_req_addr,`MON_IF.cpu_req_addr,`MON_IF.cpu_req_addr);	
@(negedge vif.CLK);
 trans.cpu_req_addr =`MON_IF.cpu_req_addr ;
 trans.cpu_req_datain=`MON_IF.cpu_req_datain;
 trans.cpu_req_dataout=`MON_IF.cpu_req_dataout;
trans.cpu_req_rw=`MON_IF.cpu_req_rw; 
trans.cpu_req_valid=`MON_IF.cpu_req_valid;

 trans.mem_req_addr=`MON_IF.mem_req_addr;
 trans.mem_req_datain=`MON_IF.mem_req_datain;
trans.mem_req_dataout=`MON_IF.mem_req_dataout;
 trans.mem_req_rw=`MON_IF.mem_req_rw;

 trans.mem_req_valid=`MON_IF.mem_req_valid;
 trans.mem_req_ready=`MON_IF.mem_req_ready;
 trans.cache_ready=`MON_IF.cache_ready;
trans.state_mode=`MON_IF.state_mode;

//trans.display("[ Monitor ]");

@(posedge vif.CLK);
@(posedge vif.CLK);

   
        mon2scb.put(trans);
      end
    end
  endtask
  
endclass
