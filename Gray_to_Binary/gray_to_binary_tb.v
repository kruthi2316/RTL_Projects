`timescale 1ns/1ps

module gray_to_binary_tb;

    reg [3:0] gray;
    wire [3:0] binary;

    gray_to_binary uut (
        .gray(gray),
        .binary(binary)
    );

    integer i;

    initial begin
        $dumpfile("gray_to_binary.vcd");
        $dumpvars(0, gray_to_binary_tb);

        // Test all 4-bit gray code values (0 to 15)
        for (i = 0; i < 16; i = i + 1) begin
            gray = i[3:0];
            #10;
        end

        $finish;
    end

endmodule