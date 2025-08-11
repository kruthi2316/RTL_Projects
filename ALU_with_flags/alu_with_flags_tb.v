// Testbench for 4-bit ALU with Flags
`timescale 1ns/1ps

module alu_with_flags_tb;

    reg [3:0] a, b;
    reg [2:0] op;
    wire [3:0] result;
    wire carry, zero, overflow;

    alu_with_flags uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .carry(carry),
        .zero(zero),
        .overflow(overflow)
    );

    initial begin
        $dumpfile("alu_with_flags.vcd");
        $dumpvars(0, alu_with_flags_tb);

        // ADD: 7 + 9 = 16 (Carry, Overflow)
        a = 4'd7; b = 4'd9; op = 3'b000; #10;

        // SUB: 3 - 7 = -4 (Overflow)
        a = 4'd3; b = 4'd7; op = 3'b001; #10;

        // AND
        a = 4'b1100; b = 4'b1010; op = 3'b010; #10;

        // OR
        op = 3'b011; #10;

        // XOR
        op = 3'b100; #10;

        // NOT
        a = 4'b0110; op = 3'b101; #10;

        // Shift Left
        a = 4'b0001; op = 3'b110; #10;

        // Shift Right
        a = 4'b1000; op = 3'b111; #10;

        // ADD: 8 + 8 = 16 → Overflow + Carry
        a = 4'd8; b = 4'd8; op = 3'b000; #10;

        $finish;
    end

endmodule