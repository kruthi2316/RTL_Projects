`timescale 1ns/1ps

module pulse_generator_tb;

    reg clk, rst, trigger;
    wire pulse;

    pulse_generator uut (
        .clk(clk),
        .rst(rst),
        .trigger(trigger),
        .pulse(pulse)
    );

    // Clock generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("pulse_generator.vcd");
        $dumpvars(0, pulse_generator_tb);

        clk = 0; rst = 1; trigger = 0; #10;
        rst = 0;

        // Apply trigger pulses
        #10 trigger = 1; #10 trigger = 1; #10 trigger = 0;
        #20 trigger = 1; #10 trigger = 0;
        #20 trigger = 1; #10 trigger = 0;

        #20 $finish;
    end

endmodule