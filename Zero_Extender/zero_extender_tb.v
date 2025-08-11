`timescale 1ns/1ps

module zero_extender_tb;

    reg  [3:0] in;
    wire [7:0] out;

    zero_extender uut (
        .in(in),
        .out(out)
    );

    integer i;

    initial begin
        $dumpfile("zero_extender.vcd");
        $dumpvars(0, zero_extender_tb);

        // Test all 4-bit combinations
        for (i = 0; i < 16; i = i + 1) begin
            in = i[3:0];
            #10;
        end

        $finish;
    end

endmodule