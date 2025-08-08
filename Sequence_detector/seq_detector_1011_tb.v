`timescale 1ns/1ps

module seq_detector_1011_tb;

    reg clk, rst, in;
    wire detected;

    seq_detector_1011 uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .detected(detected)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("seq_detector_1011.vcd");
        $dumpvars(0, seq_detector_1011_tb);

        clk = 0; rst = 1; in = 0; #10;
        rst = 0;

        // Input bitstream: 1 0 1 1 → should detect at end
        in = 1; #10;
        in = 0; #10;
        in = 1; #10;
        in = 1; #10;

        // Test overlapping sequences
        in = 1; #10; // overlaps with previous
        in = 0; #10;
        in = 1; #10;
        in = 1; #10;

        #20;
        $finish;
    end

endmodule