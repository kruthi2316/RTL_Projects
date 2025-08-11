// Testbench for 2:4 Decoder
`timescale 1ns/1ps

module decoder2to4_tb;

    reg [1:0] in;
    reg en;
    wire [3:0] out;

    // Instantiate the DUT
    decoder2to4 uut (.in(in), .en(en), .out(out));

    initial begin
        $dumpfile("decoder2to4.vcd");
        $dumpvars(0, decoder2to4_tb);

        en = 0; in = 2'b00; #10;
        en = 1; in = 2'b00; #10;
        in = 2'b01; #10;
        in = 2'b10; #10;
        in = 2'b11; #10;

        $finish;
    end

endmodule