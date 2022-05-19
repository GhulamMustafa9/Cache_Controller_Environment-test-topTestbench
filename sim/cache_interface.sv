
interface cache_intf(input logic CLK, RESETn);
  
logic [31:0] cpu_req_addr;
logic [127:0] cpu_req_datain;
logic [31:0] cpu_req_dataout;
logic cpu_req_rw; //1=write, 0=read
logic cpu_req_valid;

logic [31:0] mem_req_addr;
logic [127:0] mem_req_datain;
logic [127:0] mem_req_dataout;
logic mem_req_rw;
logic mem_req_valid;
logic mem_req_ready;
logic cache_ready;
int state_mode;
logic drv_tr;

  
  //driver clocking block
  clocking driver_cb @(posedge CLK);
    default input #1  output #1;

output cpu_req_addr;
output cpu_req_datain;
input cpu_req_dataout;
output cpu_req_rw; 
output cpu_req_valid;
input mem_req_addr;
output mem_req_datain;
input mem_req_dataout;
input mem_req_rw;
input mem_req_valid;
output mem_req_ready;
input cache_ready;
input state_mode;
output drv_tr;

  endclocking
  
  //monitor clocking block
  clocking monitor_cb @(posedge CLK);
    default input #1 output #1;

input cpu_req_addr;
input cpu_req_datain;
input cpu_req_dataout;
input cpu_req_rw; 
input cpu_req_valid;
input mem_req_addr;
input mem_req_datain;
input mem_req_dataout;
input mem_req_rw;
input mem_req_valid;
input mem_req_ready;
input cache_ready;
input state_mode;
input drv_tr;

  endclocking
  
  //driver modport
  modport DRIVER  (clocking driver_cb,input CLK,RESETn);
  
  //monitor modport  
    modport MONITOR (clocking monitor_cb,input CLK,RESETn);
  
endinterface
