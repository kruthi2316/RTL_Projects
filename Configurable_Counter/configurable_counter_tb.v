`timescale 1ns/1ps

module configurable_counter_tb;

    reg clk, rst, load, hold;
    reg [3:0] load_value;
    wire [3:0] count;

    configurable_counter uut (
        .clk(clk),
        .rst(rst),
        .load(load),
        .hold(hold),
        .load_value(load_value),
        .count(count)
    );

    initial begin
        $dumpfile("configurable_counter.vcd");
        $dumpvars(0, configurable_counter_tb);

        clk = 0; rst = 1; load = 0; hold = 0; load_value = 4'd0;

        // Reset the counter
        #10 rst = 0;

        // Normal counting
        #20;

        // Hold the counter
        hold = 1; #20;

        // Release hold
        hold = 0; #10;

        // Load value
        load_value = 4'd9;
        load = 1; #10;
        load = 0;

        // Continue counting
        #30;

        $finish;
    end

    always #5 clk = ~clk;

endmodule