`timescale 1ns/1ps

module alu4bit_tb;

    reg [3:0] a, b;
    reg [2:0] sel;
    wire [3:0] result;
    wire carry, zero;

    alu4bit uut (
        .a(a),
        .b(b),
        .sel(sel),
        .result(result),
        .carry(carry),
        .zero(zero)
    );

    initial begin
        $dumpfile("alu4bit.vcd");
        $dumpvars(0, alu4bit_tb);

        a = 4'b0101; b = 4'b0011; sel = 3'b000; #10; // ADD
        a = 4'b0101; b = 4'b0011; sel = 3'b001; #10; // SUB
        a = 4'b0101; b = 4'b0011; sel = 3'b010; #10; // AND
        a = 4'b0101; b = 4'b0011; sel = 3'b011; #10; // OR
        a = 4'b0101; b = 4'b0011; sel = 3'b100; #10; // XOR
        a = 4'b0101; b = 4'b0000; sel = 3'b101; #10; // NOT
        a = 4'b0101; b = 4'b0000; sel = 3'b110; #10; // LSHIFT
        a = 4'b0101; b = 4'b0000; sel = 3'b111; #10; // RSHIFT
        a = 4'b1111; b = 4'b1111; sel = 3'b000; #10; // ADD 
        a = 4'b1111; b = 4'b1111; sel = 3'b001; #10; // SUB 
        $finish;
    end

endmodule