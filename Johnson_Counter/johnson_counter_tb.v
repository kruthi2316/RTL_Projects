`timescale 1ns/1ps

module johnson_counter_tb;

    reg clk, rst;
    wire [3:0] q;

    johnson_counter uut (
        .clk(clk),
        .rst(rst),
        .q(q)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("johnson_counter.vcd");
        $dumpvars(0, johnson_counter_tb);

        clk = 0; rst = 1; #10;
        rst = 0;

        // Let the counter run through several states
        #100;
        $finish;
    end

endmodule