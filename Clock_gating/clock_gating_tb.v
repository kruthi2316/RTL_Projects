// Testbench for Clock Gating Circuit
`timescale 1ns/1ps

module clock_gating_tb;

    reg clk;
    reg en;
    wire gated_clk;

    // Instantiate the DUT
    clock_gating uut (
        .clk(clk),
        .en(en),
        .gated_clk(gated_clk)
    );

    initial begin
        $dumpfile("clock_gating.vcd");
        $dumpvars(0, clock_gating_tb);

        clk = 0;
        en = 0;

        #10 en = 1;   // Enable clock
        #40 en = 0;   // Disable clock
        #20 en = 1;   // Enable clock again
        #30 en = 0;   // Disable clock

        #20 $finish;
    end

    // Clock generator
    always #5 clk = ~clk; // 100 MHz

endmodule