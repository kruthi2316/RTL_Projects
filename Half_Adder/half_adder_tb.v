// TESTBENCH FOR HALF ADDER
`timescale 1ns/1ps

module half_adder_tb;

    reg a, b;
    wire sum, carry;

    // Instantiate the design under test (DUT)
    half_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, half_adder_tb);

        // Test cases
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $finish;
    end

endmodule