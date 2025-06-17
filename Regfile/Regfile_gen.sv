// Generator generates sequence of transaction objects, randomizes them, and sends to the driver via mailbox.

`define REGFILE_GEN_SV
class regfile_generator;

    mailbox gen2drv;     // Mailbox to send transactions to the driver
    int num_txns;        // Number of transactions to generate

    // Constructor: accept the mailbox handle and number of transactions
    function new(mailbox gen2drv, int num_txns);
        this.gen2drv = gen2drv;
        this.num_txns = num_txns;
    endfunction

    // Main task to create and send randomized transactions
    task run();
        repeat (num_txns) begin 
            regfile_txn t = new();
            // Randomize with constraint checking
            assert(t.randomize()) else $fatal("Randomization failed.");
            gen2drv.put(t); // Send the transaction to driver
        end
    endtask

endclass
`endif //REGFILE_GEN_SV
