// Testbench for T Flip-Flop
`timescale 1ns/1ps

module t_flip_flop_tb;

    reg clk, t;
    wire q;

    // Instantiate DUT
    t_flip_flop uut (
        .clk(clk),
        .t(t),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("t_flip_flop.vcd");
        $dumpvars(0, t_flip_flop_tb);

        clk = 0;
        t = 0;

        #10 t = 1;
        #10 t = 1;
        #10 t = 0;
        #10 t = 1;
        #10 t = 0;
        #10 $finish;
    end

endmodule