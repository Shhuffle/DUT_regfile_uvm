/* What an Environment Class Does:
1. Instantiates components: generator, driver, monitor, scoreboard
2. Creates and shares common resources (like mailbox, virtual interface)
3. Starts the run methods of these components
4. Acts as a container to manage the testbench flow*/

`define REGFILE_ENV_SV


class regfile_env;
    // Virtual interface to DUT
    virtual RegArr_if vif;


    mailbox #(regfile_txn) gen2drv;
    mailbox #(regfile_txn) mon2scb;

    // Component handles

    regfile_generator gen;
    regfile_driver drv;
    regfile_monitor mon;
    regfile_scoreboard scb;




    function new(virtual RegArr_if vif, int num_txns = 100);
        this.vif = vif;
        
        //There is in-build class for the mailbox. with new() it will invoke constructor which will allocates a new mailbox object which initializes its 
        //internal queue so it's ready to put() and get().
        gen2drv = new();
        mon2scb = new();



        gen = new(gen2drv,num_txns);
        drv = new(vif,gen2drv);
        mon = new(vif,mon2scb);
        scb = new(mon2scb);

    endfunction

    //To run all processes in parallel we use fork. Fork begins a block where each statement executes in its own concurrent process
    //join_none: Immediately return control to the next line without waiting for any of those spawned processes to finish.
    task run();
        fork 
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_none
    endtask
endclass

`endif //REGFILE_ENV_SV











