// Testbench for BCD to Binary Converter
`timescale 1ns/1ps

module bcd_to_binary_tb;

    reg [15:0] bcd;
    wire [13:0] binary;

    // Instantiate the DUT
    bcd_to_binary uut (
        .bcd(bcd),
        .binary(binary)
    );

    initial begin
        $dumpfile("bcd_to_binary.vcd");
        $dumpvars(0, bcd_to_binary_tb);

        // Test various BCD inputs
        bcd = 16'h0000; #10;  // 0000 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        bcd = 16'h0001; #10;  // 0001 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        bcd = 16'h0012; #10;  // 0012 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        bcd = 16'h0123; #10;  // 0123 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        bcd = 16'h1234; #10;  // 1234 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        bcd = 16'h9999; #10;  // 9999 decimal
        $display("BCD= %h => Binary= %d", bcd, binary);

        $finish;
    end

endmodule
