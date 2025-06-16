//as the name suggest it drives the signals from the transaction and connect it with the DUT.
//also controls handshaking or timing.





`define REGFILE_DRV_SV

class regfile_driver;
    virtual RegArr_if vif; //Here the vif is the pointer to the original interface

    regfile_txn txn;

    function new(virtual RegArr_if vif);
        this.vif = vif;  //this will connect the virtual interface passed form the tesbench to our class scoped interface
    endfunction
    //USING the transaction object we will now pass the signal to the DUT through our virtual interface
    task drive(ref regfile_txn t); //ref - pass by refrence
        vif.we     <= t.we;
        vif.re1    <= t.re1;
        vif.re2    <= t.re2;
        vif.waddr  <= t.waddr;
        vif.raddr1 <= t.raddr1;
        vif.raddr2 <= t.raddr2;
        vif.wdata  <= t.wdata;
        vif.en     <= 1;
        

        t.display();
        repeat (2) @(posedge vif.clk); //wait for two clock cycle
        vif.en <= 0; //disable the module after two clock cycle 

        repeat(2) @(posedge vif.clk) //wait for the other two second to return to the ideal state 
        //lets say the curr_state in the DUT was write (based on the transaction signal t)
        //then for one clock cycle it will write data
        //in the next cycle it will set the current_state is done 
        //finally the state changes to ideal state

    endtask

endclass 
`endif //REGFILE_DRV_SV 
        






