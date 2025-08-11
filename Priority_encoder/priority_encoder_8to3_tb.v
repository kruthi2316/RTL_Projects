// Testbench for 8:3 Priority Encoder
`timescale 1ns/1ps

module priority_encoder_8to3_tb;

    reg [7:0] in;
    wire [2:0] out;
    wire valid;

    // Instantiate DUT
    priority_encoder_8to3 uut (
        .in(in),
        .out(out),
        .valid(valid)
    );

    initial begin
        $dumpfile("priority_encoder_8to3.vcd");
        $dumpvars(0, priority_encoder_8to3_tb);

        // Only one bit set at a time
        in = 8'b00000000; #10;
        in = 8'b00000001; #10;
        in = 8'b00000010; #10;
        in = 8'b00000100; #10;
        in = 8'b00001000; #10;
        in = 8'b00010000; #10;
        in = 8'b00100000; #10;
        in = 8'b01000000; #10;
        in = 8'b10000000; #10;

        // Multiple bits set (priority test)
        in = 8'b11001000; #10;
        in = 8'b00000011; #10;

        $finish;
    end

endmodule