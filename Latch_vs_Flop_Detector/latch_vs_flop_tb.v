`timescale 1ns/1ps

module latch_vs_flop_tb;

    reg clk;
    reg en;
    reg d;
    wire q_latch;
    wire q_flop;

    reg [3:0] q_latch_prev, q_flop_prev;

    // DUT
    latch_vs_flop uut (
        .clk(clk),
        .en(en),
        .d(d),
        .q_latch(q_latch),
        .q_flop(q_flop)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("latch_vs_flop.vcd");
        $dumpvars(0, latch_vs_flop_tb);

        clk = 0; en = 0; d = 0;
        #10;

        d = 1; en = 1; #10;
        d = 0; en = 1; #10;
        en = 0; #10;
        d = 1; #10; // q_latch may change here; q_flop should not

        $display("Manual check:");
        $display("q_latch may change when en is low – potential latch behavior.");
        $display("q_flop should only change on clk ↑ with en high – flip-flop behavior.");

        #20;
        $finish;
    end

endmodule