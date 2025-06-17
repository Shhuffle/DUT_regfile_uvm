`timescale 1ns/1ps

module tb_top;
    // Clock and reset
    logic clk;
    logic rst; 

    // Instantiate the interface and connect clock/reset
    RegArr_if if_inst (
        .clk(clk),
        .rst(rst)
    );

    // Instantiate the DUT, binding the interface instance to the DUT's modport
    Reg_Arr dut (
        .RegIf(if_inst)  // Port name in DUT is 'RegIf', so pass 'if_inst'
    );

    // Environment handle
    regfile_env env;

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Test sequence
    initial begin 
        // Create the environment, passing interface and # of transactions
        env = new(if_inst, 100);

        // Apply reset for two cycles
        rst = 1;
        repeat (2) @(posedge clk);
        rst = 0;

        // Start the environment (generator, driver, monitor, scoreboard)
        env.run();

        // Let simulation run for a while, then finish
        #2000;
        $display("Testbench completed at time %0t", $time);
        $finish;
    end    
endmodule
