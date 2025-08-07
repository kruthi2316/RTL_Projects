// Testbench for 1:2 Demultiplexer
`timescale 1ns/1ps

module demux1to2_tb;

    reg in;
    reg sel;
    wire y0, y1;

    // Instantiate the DUT
    demux1to2 uut (
        .in(in),
        .sel(sel),
        .y0(y0),
        .y1(y1)
    );

    initial begin
        $dumpfile("demux1to2.vcd");
        $dumpvars(0, demux1to2_tb);

        // Test all combinations
        in = 0; sel = 0; #10;
        in = 1; sel = 0; #10;
        in = 0; sel = 1; #10;
        in = 1; sel = 1; #10;

        $finish;
    end

endmodule