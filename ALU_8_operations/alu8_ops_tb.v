// Testbench for alu8_ops.v
`timescale 1ns/1ps

module alu8_ops_tb;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] a, b;
    reg  [2:0]       op;
    wire [WIDTH-1:0] result;
    wire             flag_c, flag_z, flag_v, flag_n;

    alu8_ops #(.WIDTH(WIDTH)) uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result),
        .flag_c(flag_c),
        .flag_z(flag_z),
        .flag_v(flag_v),
        .flag_n(flag_n)
    );

    initial begin
        $dumpfile("alu8_ops.vcd");
        $dumpvars(0, alu8_ops_tb);

        // Test ADD: normal, carry, overflow
        a = 8'd10; b = 8'd5; op = 3'b000; #10; // 10 + 5 = 15 (no carry, no overflow)
        $display("ADD: %0d + %0d = %0d | C:%b V:%b Z:%b N:%b", a, b, result, flag_c, flag_v, flag_z, flag_n);

        a = 8'd200; b = 8'd100; op = 3'b000; #10; // 200 + 100 = 44 (carry), unsigned carry
        $display("ADD: %0d + %0d = %0d | C:%b V:%b", a, b, result, flag_c, flag_v);

        // Signed overflow:  127 + 1 = -128 (overflow)
        a = 8'd127; b = 8'd1; op = 3'b000; #10;
        $display("ADD OVF: %0d + %0d = %0d | C:%b V:%b N:%b", a, b, result, flag_c, flag_v, flag_n);

        // Test SUB
        a = 8'd50; b = 8'd20; op = 3'b001; #10; // 50 - 20 = 30, no borrow
        $display("SUB: %0d - %0d = %0d | C(no-borrow):%b V:%b", a, b, result, flag_c, flag_v);

        a = 8'd20; b = 8'd50; op = 3'b001; #10; // 20 - 50 => borrow (flag_c=0)
        $display("SUB BORROW: %0d - %0d = %0d | C(no-borrow):%b V:%b", a, b, result, flag_c, flag_v);

        // Signed subtraction overflow: -128 - 1 => overflow in two's complement for 8-bit
        a = 8'd128; b = 8'd1; op = 3'b001; #10; // interpreting as unsigned, but overflow check uses MSB
        $display("SUB OVF: a:%b b:%b res:%b | V:%b N:%b C:%b", a, b, result, flag_v, flag_n, flag_c);

        // Logical ops
        a = 8'b11001100; b = 8'b10101010; op = 3'b010; #10; // AND
        $display("AND: a=%b b=%b res=%b", a, b, result);

        op = 3'b011; #10; // OR
        $display("OR  : res=%b", result);

        op = 3'b100; #10; // XOR
        $display("XOR : res=%b", result);

        // NOT
        op = 3'b101; #10;
        $display("NOT : a=%b res=%b", a, result);

        // Shift left: expect carry = bit shifted out
        a = 8'b10000001; op = 3'b110; #10;
        $display("SLL : a=%b res=%b C:%b", a, result, flag_c);

        // Shift right logical: carry = LSB
        a = 8'b00000011; op = 3'b111; #10;
        $display("SRL : a=%b res=%b C:%b", a, result, flag_c);

        // Zero flag test
        a = 8'd5; b = 8'd5; op = 3'b001; #10; // 5 - 5 = 0
        $display("ZERO test: res=%d Z:%b", result, flag_z);

        #20;
        $finish;
    end

endmodule