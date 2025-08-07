// Testbench for JK Flip-Flop
`timescale 1ns/1ps

module jk_flip_flop_tb;

    reg clk, j, k;
    wire q;

    jk_flip_flop uut (
        .clk(clk),
        .j(j),
        .k(k),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("jk_flip_flop.vcd");
        $dumpvars(0, jk_flip_flop_tb);

        clk = 0; j = 0; k = 0;

        // Test all input combinations
        #10 j = 0; k = 0;  // No change
        #10 j = 1; k = 0;  // Set
        #10 j = 0; k = 1;  // Reset
        #10 j = 1; k = 1;  // Toggle
        #10 j = 1; k = 1;  // Toggle again
        #10 j = 0; k = 0;  // No change
        #10 $finish;
    end

endmodule