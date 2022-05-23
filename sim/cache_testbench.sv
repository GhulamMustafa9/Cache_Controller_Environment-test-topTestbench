
//including interfcae and testcase files
`include "cache_interface.sv"
`include "cache_wr_rd_test.sv"

module cache_tbench_top;
  
  //clock and reset signal declaration
  bit CLK;
  bit RESETn;
  
  //clock generation
  always #5 CLK = ~ CLK; 

  //creatinng instance of interface, inorder to connect DUT and testcase
  cache_intf intf(CLK,RESETn);
  
  //Testcase instance, interface handle is passed to test as an argument
  cache_test t1(intf);
  //reset Generation
  initial begin
CLK = 1'b1;
 RESETn = 1'b1; 
@(posedge CLK); 
@(posedge CLK); 
 RESETn = 1'b0;
  end

cache_controller DUT (
    .clk	       (intf.CLK),
    .rst_n             (intf.RESETn),
    .cpu_req_addr      (intf.cpu_req_addr),  
    .cpu_req_datain    (intf.cpu_req_datain),
    .cpu_req_dataout   (intf.cpu_req_dataout),
    .cpu_req_rw        (intf.cpu_req_rw),
    .cpu_req_valid     (intf.cpu_req_valid),
    .cache_ready       (intf.cache_ready),   
    .mem_req_addr      (intf.mem_req_addr),  
    .mem_req_datain    (intf.mem_req_datain),
    .mem_req_dataout   (intf.mem_req_dataout),
    .mem_req_rw        (intf.mem_req_rw),
    .mem_req_valid     (intf.mem_req_valid),
    .mem_req_ready     (intf.mem_req_ready),
    .state_mode        (intf.state_mode)
	);

  //enabling the wave dump
  initial begin 
    //$dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
