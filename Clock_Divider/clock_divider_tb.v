`timescale 1ns/1ps

module clock_divider_tb;

    reg clk, rst;
    wire clk_out;

    clock_divider uut (
        .clk(clk),
        .rst(rst),
        .clk_out(clk_out)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("clock_divider.vcd");
        $dumpvars(0, clock_divider_tb);

        clk = 0;
        rst = 1; #15;
        rst = 0;

        #200;
        $finish;
    end

endmodule