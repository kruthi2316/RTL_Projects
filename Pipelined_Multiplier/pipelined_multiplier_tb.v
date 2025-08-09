`timescale 1ns/1ps

module pipelined_multiplier_tb;

    parameter N = 4;
    reg clk, rst;
    reg in_valid;
    reg [N-1:0] a, b;
    wire [(2*N)-1:0] product;
    wire out_valid;

    // Instantiate the DUT
    pipelined_multiplier #(.N(N)) uut (
        .clk(clk),
        .rst(rst),
        .in_valid(in_valid),
        .a(a),
        .b(b),
        .product(product),
        .out_valid(out_valid)
    );

    integer i;
    integer expected;  // will store expected product for checking
    integer errors;

    initial begin
        $dumpfile("pipelined_multiplier.vcd");
        $dumpvars(0, pipelined_multiplier_tb);

        clk = 0;
        rst = 1;
        in_valid = 0;
        a = 0;
        b = 0;
        errors = 0;

        #12 rst = 0; // release reset

        // Apply several test cases
        for (i = 0; i < 10; i = i + 1) begin
            a = i;
            b = 10 - i;
            in_valid = 1;
            expected = a * b;
            #10; // 1 clock cycle
            in_valid = 0;

            // Wait for output to become valid
            wait (out_valid == 1);
            if (product !== expected) begin
                $display("Mismatch: a=%0d b=%0d => got %0d, expected %0d", a, b, product, expected);
                errors = errors + 1;
            end else begin
                $display("PASS: a=%0d b=%0d => product=%0d", a, b, product);
            end
            #10; // gap before next input
        end

        $display("Test complete. Errors = %0d", errors);
        $finish;
    end

    always #5 clk = ~clk; // 10ns clock period

endmodule