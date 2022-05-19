//`include "cache_transaction.sv"

`define DRIV_IF vif.driver_cb
class cache_driver;

  //used to count the number of transactions
  int no_transactions;
  
  //creating virtual interface handle
  virtual cache_intf vif;
  
   reg [127:0] mem [2**16]; 
  //creating mailbox handle
  mailbox gen2driv;
  int fd_w; 

  //constructor
  function new(virtual cache_intf vif,mailbox gen2driv);
    //getting the interface
    this.vif = vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  task reset;
	wait(vif.RESETn);
	vif.cpu_req_addr = 32'd0; 
	vif.cpu_req_datain = 128'd0; 
	vif.cpu_req_rw = 1'b0; 
	vif.cpu_req_valid = 1'b0; 
	vif.mem_req_datain = 128'd0; 
	vif.mem_req_ready = 1'b1;
	wait(!vif.RESETn);
	$readmemh("initial_main_memory.mem", mem);
	@(posedge vif.CLK);
  endtask



  task drive;
      cache_transaction trans;
      gen2driv.get(trans);
	trans.display("[ Driver ]");
	
	if(trans.cpu_req_rw) begin//-------------------------------

		wait(`DRIV_IF.cache_ready); 
		//$display ("cache ready =%0d",$time, `DRIV_IF.cache_ready);
		`DRIV_IF.cpu_req_addr <= trans.cpu_req_addr; 
		`DRIV_IF.cpu_req_rw <= trans.cpu_req_rw; 
		`DRIV_IF.cpu_req_valid <= 1'b1; 
		`DRIV_IF.cpu_req_datain <= trans.cpu_req_datain; 
 	@(posedge vif.CLK) 
		`DRIV_IF.cpu_req_addr <= 32'd0; 
		`DRIV_IF.cpu_req_rw <= 1'b0; 
		`DRIV_IF.cpu_req_valid <= 1'b0; 
		`DRIV_IF.cpu_req_datain <= 128'd0;  
        	$display (" Write data - tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  req-addr=%0d(h%6h)(b%0b)  Write", trans.cpu_req_addr[31:14], trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr[13:4], trans.cpu_req_addr[3:0], trans.cpu_req_addr[3:0], trans.cpu_req_addr,trans.cpu_req_addr,trans.cpu_req_addr);	
	@(posedge vif.CLK) $display ("");


			end  //if(trans.cpu_req_rw) ----------------------
	else begin	//-------------------------

wait(`DRIV_IF.cache_ready); 

	`DRIV_IF.cpu_req_addr <= trans.cpu_req_addr; 
	`DRIV_IF.cpu_req_rw <= trans.cpu_req_rw; 
	`DRIV_IF.cpu_req_valid <= 1'b1;  
@(posedge vif.CLK) 
	`DRIV_IF.cpu_req_addr <= 32'd0; 
	`DRIV_IF.cpu_req_rw <= 1'b0; 
	`DRIV_IF.cpu_req_valid <= 1'b0; 
  	 //$display (" tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  mem-addr=%0d(h%6h)(b%0b)  Read",  trans.cpu_req_addr[31:14], trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr[13:4], trans.cpu_req_addr[3:0], trans.cpu_req_addr[3:0], trans.cpu_req_addr,trans.cpu_req_addr,trans.cpu_req_addr);	
@(posedge vif.CLK)

 if (`DRIV_IF.state_mode == 1)  begin //$display ("[%0t] - HIT  ",$time);
  	 $display (" Read HIT - tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  mem-addr=%0d(h%6h)(b%0b)  Read", trans.cpu_req_addr[31:14], trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr[13:4], trans.cpu_req_addr[3:0], trans.cpu_req_addr[3:0], trans.cpu_req_addr,trans.cpu_req_addr,trans.cpu_req_addr);	
	@(posedge vif.CLK) 
		$display ("");
 
end

else if (`DRIV_IF.state_mode == 2 || `DRIV_IF.state_mode == 3) begin 
if (`DRIV_IF.state_mode == 2) begin //$display ("[%0t] - read clean  ",$time);
$display (" Read Clean - tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  mem-addr=%0d(h%6h)(b%0b)  Read",  trans.cpu_req_addr[31:14], trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr[13:4], trans.cpu_req_addr[3:0], trans.cpu_req_addr[3:0], trans.cpu_req_addr,trans.cpu_req_addr,trans.cpu_req_addr);	   
`DRIV_IF.mem_req_ready <= 1'b0;
@(posedge vif.CLK) 
`DRIV_IF.mem_req_datain <= mem[`DRIV_IF.mem_req_addr]; 
`DRIV_IF.mem_req_ready <= 1'b1;
@(posedge vif.CLK)
@(posedge vif.CLK)
@(posedge vif.CLK); `DRIV_IF.mem_req_ready <= 1'b1; 
$display ("");

end 
else if (`DRIV_IF.state_mode == 3) begin //$display (" - read dirty  ",$time);
$display (" Read Dirty - tag=%0d(%20b) index=%0d(%0b) offset=%0d(%0b)  mem-addr=%0d(h%6h)(b%0b)  Read",  trans.cpu_req_addr[31:14], trans.cpu_req_addr[31:14], trans.cpu_req_addr[13:4], trans.cpu_req_addr[13:4], trans.cpu_req_addr[3:0], trans.cpu_req_addr[3:0], trans.cpu_req_addr,trans.cpu_req_addr,trans.cpu_req_addr);	
 
@(negedge `DRIV_IF.mem_req_valid)
	`DRIV_IF.mem_req_ready <= 1'b0; 
	mem[`DRIV_IF.mem_req_addr] <= `DRIV_IF.mem_req_dataout; 
  @(posedge vif.CLK)
	`DRIV_IF.mem_req_datain <= mem[`DRIV_IF.mem_req_addr];     
  		@(negedge `DRIV_IF.mem_req_valid) 
		`DRIV_IF.mem_req_ready <= 1'b0;
  	@(posedge vif.CLK)
		`DRIV_IF.mem_req_ready <= 1'b1;
@(posedge vif.CLK)
@(posedge vif.CLK)
@(posedge vif.CLK)`DRIV_IF.mem_req_ready <= 1'b1;
$display ("");

end

end


		end  	// else begin ------------------------


     no_transactions++;  

if (gen2driv.num()==0) begin
	fd_w = $fopen ("Result-main_memory.mem", "w"); 	// Open a new file in write mode and store file descriptor in fd_w
	for (int i = 0; i < $size(mem); i++)
		$fwrite (fd_w,"%7d(%5h)  %32h\n",i,i, mem[i] );
	#20 $fclose(fd_w);


end
    
  endtask
  
   
  //
  task main;
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(vif.RESETn);
        end
        //Thread-2: Calling drive task
        begin
          forever
            drive();
        end
      join_any
      disable fork;

    end


  endtask
   
endclass
