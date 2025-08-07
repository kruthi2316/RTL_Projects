// Testbench for 3:8 Decoder
`timescale 1ns/1ps

module decoder3to8_tb;

    reg [2:0] in;
    reg en;
    wire [7:0] out;

    // Instantiate the DUT
    decoder3to8 uut (
        .in(in),
        .en(en),
        .out(out)
    );

    initial begin
        $dumpfile("decoder3to8.vcd");
        $dumpvars(0, decoder3to8_tb);

        en = 0; in = 3'b000; #10; // Should output 00000000
        en = 1; in = 3'b000; #10; // Should output 00000001
        in = 3'b001; #10;         // Should output 00000010
        in = 3'b010; #10;         // Should output 00000100
        in = 3'b011; #10;         // Should output 00001000
        in = 3'b100; #10;         // Should output 00010000
        in = 3'b101; #10;         // Should output 00100000
        in = 3'b110; #10;         // Should output 01000000
        in = 3'b111; #10;         // Should output 10000000

        $finish;
    end

endmodule