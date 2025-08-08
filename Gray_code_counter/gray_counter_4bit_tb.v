`timescale 1ns/1ps

module gray_counter_4bit_tb;

    reg clk, rst;
    wire [3:0] gray;

    gray_counter_4bit uut (
        .clk(clk),
        .rst(rst),
        .gray(gray)
    );

    // Generate clock signal
    always #5 clk = ~clk;

    initial begin
        $dumpfile("gray_counter_4bit.vcd");
        $dumpvars(0, gray_counter_4bit_tb);

        clk = 0;
        rst = 1; #10;
        rst = 0;

        // Run for 20 clock cycles
        #200;
        $finish;
    end

endmodule