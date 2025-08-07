// Testbench for 8-bit Up/Down Counter
`timescale 1ns/1ps

module updown_counter_8bit_tb;

    reg clk, rst, up_down;
    wire [7:0] count;

    // Instantiate the DUT
    updown_counter_8bit uut (
        .clk(clk),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("updown_counter_8bit.vcd");
        $dumpvars(0, updown_counter_8bit_tb);

        clk = 0;
        rst = 1;
        up_down = 1; // Start with up count
        #10;

        rst = 0;

        // Count up
        #50;

        // Switch to down
        up_down = 0;
        #50;

        // Reset
        rst = 1; #10;
        rst = 0; #10;

        $finish;
    end

endmodule