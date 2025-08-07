// Testbench for SR Flip-Flop
`timescale 1ns/1ps

module sr_flip_flop_tb;

    reg clk, s, r;
    wire q;

    sr_flip_flop uut (
        .clk(clk),
        .s(s),
        .r(r),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("sr_flip_flop.vcd");
        $dumpvars(0, sr_flip_flop_tb);

        clk = 0; s = 0; r = 0;

        // Test each case
        #10 s = 0; r = 0; // Hold
        #10 s = 1; r = 0; // Set
        #10 s = 0; r = 1; // Reset
        #10 s = 1; r = 1; // Invalid
        #10 s = 0; r = 0; // Hold
        #10 $finish;
    end

endmodule