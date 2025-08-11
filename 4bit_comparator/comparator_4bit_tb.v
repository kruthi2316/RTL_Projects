// Testbench for 4-bit Comparator
`timescale 1ns/1ps

module comparator_4bit_tb;

    reg [3:0] a, b;
    wire a_gt_b, a_eq_b, a_lt_b;

    // Instantiate DUT
    comparator_4bit uut (
        .a(a),
        .b(b),
        .a_gt_b(a_gt_b),
        .a_eq_b(a_eq_b),
        .a_lt_b(a_lt_b)
    );

    initial begin
        $dumpfile("comparator_4bit.vcd");
        $dumpvars(0, comparator_4bit_tb);

        // Test cases
        a = 4'b0001; b = 4'b0010; #10;  // a < b
        a = 4'b1010; b = 4'b1010; #10;  // a = b
        a = 4'b1110; b = 4'b1010; #10;  // a > b
        a = 4'b0000; b = 4'b0000; #10;  // a = b
        a = 4'b0111; b = 4'b1000; #10;  // a < b
        a = 4'b1111; b = 4'b0001; #10;  // a > b

        $finish;
    end

endmodule
