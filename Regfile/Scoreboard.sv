//It is a passive checker that compares expected output (form perdeiction logic) and actual output form the DUT via the monitor 


//What does a Scoreboard Do?
// Receives transactions (typically from the monitor).
// Predicts expected outputs using some reference logic.
// Compares expected vs. actual outputs.
// Logs mismatches or confirms correctness.



//MailBox 
//In systemVerilog, a mailbox is a synchronization and communication mechanism used to pass data between different processes or components
//-like from a monitor to a scoreboard, or from a generator to a driver


//  What Is a Mailbox?
// A mailbox is like a thread-safe queue:
// One component can put data into it.
// Another can get data from it.
// It ensures safe communication between parallel tasks (like classes or processes).

`define REGFILE_SCB_SV
class regfile_scoreboard;
    mailbox #(regfile_txn) mon2scb; //to receive transaction form monitor

    //Refrence model of register file (8 registers)
    bit [31:0] ref_mem {0:7};

    function new(mailbox #(regfile_txn) mon2scb);
        this.mon2scb = mon2scb;
         // Optional: initialize memory to 0
    foreach (ref_mem[i]) ref_mem[i] = 0;
  endfunction

  task run();
    forever begin 
        regfile_txn t;
        mon2scb.get(t); // Get transaction object form monitor

        if(t.we) begin 
            ref_mem[t.waddr] = t.wdata;
        end
        if(t.re1) begin 
            if(ref_mem[t.raddr1] !== rdata1)
            $error("[SCB] Mismatch @ raddr1=%0d: Expected=0x%0h, Got=0x%0h",
                  t.raddr1, ref_mem[t.raddr1], t.rdata1);
        else
          $display("[SCB] Read1 OK @ raddr1=%0d: Data=0x%0h", t.raddr1, t.rdata1);
      end

      if (t.re2) begin
        if (ref_mem[t.raddr2] !== t.rdata2)
          $error("[SCB] Mismatch @ raddr2=%0d: Expected=0x%0h, Got=0x%0h",
                  t.raddr2, ref_mem[t.raddr2], t.rdata2);
        else
          $display("[SCB] Read2 OK @ raddr2=%0d: Data=0x%0h", t.raddr2, t.rdata2);
      end
    end
  endtask

endclass

`endif // REGFILE_SCB_SV
   





