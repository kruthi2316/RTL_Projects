`timescale 1ns/1ps

module binary_to_gray_tb;

    reg [3:0] binary;
    wire [3:0] gray;

    binary_to_gray uut (
        .binary(binary),
        .gray(gray)
    );

    integer i;  // ← Fix here

    initial begin
        $dumpfile("binary_to_gray.vcd");
        $dumpvars(0, binary_to_gray_tb);

        // Test all 4-bit combinations
        for (i = 0; i < 16; i = i + 1) begin
            binary = i[3:0];
            #10;
        end

        $finish;
    end

endmodule