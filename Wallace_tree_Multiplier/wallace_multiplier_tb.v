// Testbench for Wallace Tree Multiplier
`timescale 1ns/1ps
module wallace_multiplier_tb;

    reg  [3:0] a, b;
    wire [7:0] product;

    wallace_multiplier uut (
        .a(a),
        .b(b),
        .product(product)
    );

    initial begin
        $dumpfile("wallace_multiplier.vcd");
        $dumpvars(0, wallace_multiplier_tb);

        a = 4'b0011; b = 4'b0101; #10; // 3 * 5
        a = 4'b1111; b = 4'b1111; #10; // 15 * 15
        a = 4'b1001; b = 4'b0110; #10; // 9 * 6
        a = 4'b0000; b = 4'b1010; #10; // 0 * 10

        $finish;
    end

endmodule