// Testbench for 4-bit Carry Lookahead Adder
`timescale 1ns/1ps

module cla_4bit_tb;

    reg [3:0] a, b;
    reg cin;
    wire [3:0] sum;
    wire cout;

    // Instantiate DUT
    cla_4bit uut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        $dumpfile("cla_4bit.vcd");
        $dumpvars(0, cla_4bit_tb);

        // Test vectors
        a = 4'b0000; b = 4'b0000; cin = 0; #10;
        a = 4'b0011; b = 4'b0101; cin = 0; #10;
        a = 4'b1010; b = 4'b0110; cin = 1; #10;
        a = 4'b1111; b = 4'b0001; cin = 0; #10;
        a = 4'b1111; b = 4'b1111; cin = 1; #10;

        $finish;
    end

endmodule