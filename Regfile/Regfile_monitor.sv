//A monitor will simply observe the transaction signal and the signal at the port of the DUT
//It doesnt drive input or output and remains passive 
//It contains a vertual interface , transaction objet.
//it watches everything and records important events.


//it stores the signals from the port of the DUT and store them in new transaction object and use them 
//to display or compare. 





`define REGFILE_MON_SV
class regfile_monitor;
    virtual RegArr_if vif;

    function new (virtual RegArr_if vif);
        this.vif = vif;
    endfunction

    //monitor task will run forever
    task run();
        forever begin
            @(posedge vif.clk);
            if (vif.en) begin
                regfile_txn t = new(); //created a object of transaction which will store the signals driven by the driver to monitor them
                
                t.we = vif.we;
                t.re1 = vif.re1;
                t.re2 = vif.re2;
                t.waddr = vif.waddr;
                t.wdata = vif.wdata;
                t.raddr1 = vif.raddr1;
                t.raddr2 = vif.raddr2;
                t.rdata1 = vif.rdata1;
                t.rdata2 = vif.rdata2;

                if (vif.we)
                    $display("[MON] Write Detected: Addr = %0d, Data = 0x%0h", t.waddr, t.wdata);
                if (vif.re1)
                    $display("[MON] Read1 Detected: Addr = %0d, Data = 0x%0h", t.raddr1, t.rdata1);
                if (vif.re2)
                    $display("[MON] Read2 Detected: Addr = %0d, Data = 0x%0h", t.raddr2, t.rdata2);
            end
        end
    endtask 
endclass
`endif //REGFILE_MON_SV



