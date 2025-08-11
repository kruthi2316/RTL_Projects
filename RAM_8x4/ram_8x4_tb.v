// Testbench for 8x4 RAM
`timescale 1ns/1ps

module ram_8x4_tb;

    reg clk;
    reg en;
    reg [2:0] addr;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Instantiate DUT
    ram_8x4 uut (
        .clk(clk),
        .en(en),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("ram_8x4.vcd");
        $dumpvars(0, ram_8x4_tb);

        clk = 0;

        // Write data
        en = 1;
        addr = 3'b000; data_in = 4'b0001; #10;
        addr = 3'b001; data_in = 4'b0010; #10;
        addr = 3'b010; data_in = 4'b0011; #10;
        addr = 3'b011; data_in = 4'b0100; #10;

        // Read data
        en = 0;
        addr = 3'b000; #10;
        addr = 3'b001; #10;
        addr = 3'b010; #10;
        addr = 3'b011; #10;

        $finish;
    end

endmodule