
class cache_transaction;

     bit [127:0] cpu_req_datain;
rand bit [31:0] cpu_req_addr;
rand bit [31:0] cpu_req_datain_0;
rand bit [31:0] cpu_req_datain_1;
rand bit [31:0] cpu_req_datain_2;
rand bit [31:0] cpu_req_datain_3;
rand bit cpu_req_rw;

bit [127:0] mem_req_dataout;
bit mem_req_rw;
bit mem_req_valid;
bit mem_req_ready;
bit cache_ready;
int state_mode;
bit [31:0] cpu_req_dataout;
bit  cpu_req_valid;
bit [31:0] mem_req_addr;
bit [127:0] mem_req_datain;

  constraint cache_rand  { 	(cpu_req_addr inside {[0:(2**16)-1]});(cpu_req_addr % 16 == 0) ;
				(cpu_req_datain_0 inside {[0:((2**16) -1)]});
				(cpu_req_datain_1 inside {[0:((2**16) -1)]});
				(cpu_req_datain_2 inside {[0:((2**16) -1)]});
				(cpu_req_datain_3 inside {[0:((2**16) -1)]});  }

  constraint wr_rand  { cpu_req_rw dist {0:=70, 1:=30};} //generate 30% one and 70% zero
    			    	
 //deep copy method
  function cache_transaction do_copy();   
    cache_transaction trans;
    trans = new();
    trans.cpu_req_addr = this.cpu_req_addr; //{this.cpu_req_addr[29:0],2'b00};
    trans.cpu_req_datain = {this.cpu_req_datain_0, this.cpu_req_datain_1, this.cpu_req_datain_2,this.cpu_req_datain_3};//this.cpu_req_datain_0;//this.cpu_req_datain;//this.cpu_req_datain;//{this.cpu_req_datain_0, this.cpu_req_datain_1, this.cpu_req_datain_2, this.cpu_req_datain_3} ;
    trans.cpu_req_rw = this.cpu_req_rw;
    return trans;
  endfunction
endclass












