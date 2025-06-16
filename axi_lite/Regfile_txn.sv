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

    function void display();
        if(we) $display("[TXN] WRITE addr = %0d data =0x%0h" , waddr , wdata);
        if(re1) $display("[TXN] READ1 addr = %0d" , raddr1);
        if(re2) $display("[TXN] READ2 addr = %0d" , raddr2);
        else 
            $display("[TXN] BI-OP or IDLE");
    endfunction 
endclass
`endif //REGFILE_TXN_SV