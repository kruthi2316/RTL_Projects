// Testbench for D Flip-Flop
`timescale 1ns/1ps

module d_flip_flop_tb;

    reg clk, d;
    wire q;

    // Instantiate DUT
    d_flip_flop uut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    // Clock generator
    always #5 clk = ~clk;

    initial begin
        $dumpfile("d_flip_flop.vcd");
        $dumpvars(0, d_flip_flop_tb);

        clk = 0;
        d = 0;

        #12 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 1;
        #10 d = 0;
        #10 $finish;
    end

endmodule