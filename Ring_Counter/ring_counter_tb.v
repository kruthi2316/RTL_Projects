`timescale 1ns/1ps

module ring_counter_tb;

    reg clk, rst;
    wire [3:0] q;

    ring_counter uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("ring_counter.vcd");
        $dumpvars(0, ring_counter_tb);

        clk = 0; rst = 1; #10;
        rst = 0;

        // Let it run for several cycles
        #100;
        $finish;
    end

endmodule