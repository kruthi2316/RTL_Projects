// Testbench for Time-Multiplexed 7-Segment Display Driver
`timescale 1ns/1ps

module time_mux_7seg_driver_tb;

    reg clk;
    reg rst_n;
    reg [15:0] digits_bcd;
    wire [6:0] seg;
    wire [3:0] digit_enable;

    time_mux_7seg_driver uut (
        .clk(clk),
        .rst_n(rst_n),
        .digits_bcd(digits_bcd),
        .seg(seg),
        .digit_enable(digit_enable)
    );

    initial clk = 0;
    always #10 clk = ~clk; // 50 MHz clock (period = 20ns)

    initial begin
        $dumpfile("time_mux_7seg_driver.vcd");
        $dumpvars(0, time_mux_7seg_driver_tb);

        rst_n = 0; digits_bcd = 16'h0000;
        #50;
        rst_n = 1;

        // Display "1234"
        digits_bcd = 16'h1234;
        #10000;  // Run simulation for a while to see multiplexing

        // Display "5678"
        digits_bcd = 16'h5678;
        #10000;

        // Display "9999"
        digits_bcd = 16'h9999;
        #10000;

        $finish;
    end

endmodule