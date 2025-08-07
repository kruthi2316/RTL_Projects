// Testbench for 4:1 Multiplexer - mux4to1_tb.v
`timescale 1ns/1ps

module mux4to1_tb;

    reg a, b, c, d;
    reg [1:0] sel;
    wire y;

    // Instantiate the module
    mux4to1 uut (
        .a(a), .b(b), .c(c), .d(d),
        .sel(sel),
        .y(y)
    );

    initial begin
        $dumpfile("mux4to1.vcd");
        $dumpvars(0, mux4to1_tb);

        // Test each selection case
        a = 1; b = 0; c = 1; d = 0;

        sel = 2'b00; #10;  // Expect y = a
        sel = 2'b01; #10;  // Expect y = b
        sel = 2'b10; #10;  // Expect y = c
        sel = 2'b11; #10;  // Expect y = d

        $finish;
    end

endmodule