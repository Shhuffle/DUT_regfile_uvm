// As the name suggests, it drives the signals from the transaction and connects them to the DUT.
// Also controls handshaking or timing.

`define REGFILE_DRV_SV

class regfile_driver;
    virtual RegArr_if vif;           // Pointer to the original interface
    mailbox gen2drv;                 // Mailbox to receive transactions from generator

    function new(virtual RegArr_if vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    // Receives all transaction streams from the generator
    task run();
        regfile_txn t;
        forever begin 
            gen2drv.get(t);  // Get transaction from mailbox
            drive(t);        // Drive transaction to DUT
        end 
    endtask

    // Using the transaction object, pass the signal to the DUT via the virtual interface
    task drive(ref regfile_txn t);  // Pass-by-reference for possible future scoreboard use
        vif.we     <= t.we;
        vif.re1    <= t.re1;
        vif.re2    <= t.re2;
        vif.waddr  <= t.waddr;
        vif.raddr1 <= t.raddr1;
        vif.raddr2 <= t.raddr2;
        vif.wdata  <= t.wdata;
        vif.en     <= 1;

        t.display();  // Optional debug

        repeat (2) @(posedge vif.clk); // Wait two cycles for op to complete
        vif.en <= 0;                   // Disable signals

        repeat (2) @(posedge vif.clk); // Wait extra time to return to idle
    endtask
endclass

`endif // REGFILE_DRV_SV
