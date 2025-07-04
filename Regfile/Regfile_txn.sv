//Purpose of the transaction class
//It will generate the random input signal we will need to test our DUT and group them in a single object
//different constraints can be used to limit the random value to certain order or pattern.
//also we can display the generated signal values.

`ifndef REGFILE_TXN_SV
`define REGFILE_TXN_SV
class regfile_txn;
    rand bit we;
    rand bit re1;
    rand bit re2;
    rand bit [31:0] wdata;
    rand bit [2:0] waddr;
    rand bit [2:0] raddr1;
    rand bit [2:0] raddr2;

    logic bit [31:0] rdata1;
    logic bit [31:0] rdata2; //will be used by the monitor to store the read value form the interface.

     //it will ensure that there is no simultanesous read and write to the same mem location. 
     constraint no_mem_overlap {
    (we && re1)  -> (waddr != raddr1);  //NO procedural if is allowed in constraint.
    (re2 && re1) -> (raddr1 != raddr2);
    (we && re2)  -> (waddr != raddr2);
    }
    

    constraint no_overflow {
        raddr1 inside {[0:7]};
        raddr2 inside {[0:7]};
        waddr inside {[0:7]};
    } 
    //to ensure one operation at a time becuase our testbench is desined in such a way that only one operation is monitored at a time.
    constraint one_op{
        we + re1 + re2 <= 1;
    }

    function void display();
        if(we) $display("[TXN] WRITE addr = %0d data =0x%0h" , waddr , wdata);
        if(re1) $display("[TXN] READ1 addr = %0d" , raddr1);
        if(re2) $display("[TXN] READ2 addr = %0d" , raddr2);
        else 
            $display("[TXN] BI-OP or IDLE");
    endfunction 
endclass
`endif //REGFILE_TXN_SV