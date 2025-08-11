`timescale 1ns/1ps

module sign_extender_tb;

    reg  [3:0] in;
    wire [7:0] out;

    sign_extender uut (
        .in(in),
        .out(out)
    );

    integer i;

    initial begin
        $dumpfile("sign_extender.vcd");
        $dumpvars(0, sign_extender_tb);

        // Loop through all 4-bit values
        for (i = 0; i < 16; i = i + 1) begin
            in = i[3:0];
            #10;
        end

        $finish;
    end

endmodule