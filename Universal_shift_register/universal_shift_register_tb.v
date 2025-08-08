// Testbench for Universal 4-bit Shift Register
`timescale 1ns/1ps

module universal_shift_register_tb;

    reg clk;
    reg rst;
    reg [1:0] mode;
    reg s_in;
    reg [3:0] p_in;
    wire s_out;
    wire [3:0] p_out;

    // Instantiate DUT
    universal_shift_register uut (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .s_in(s_in),
        .p_in(p_in),
        .s_out(s_out),
        .p_out(p_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("universal_shift_register.vcd");
        $dumpvars(0, universal_shift_register_tb);

        clk = 0; rst = 1; mode = 2'b00; s_in = 0; p_in = 4'b0000;
        #10;

        rst = 0;

        // Load parallel (PIPO)
        mode = 2'b10; p_in = 4'b1101; #10;

        // Hold
        mode = 2'b00; #10;

        // Shift left (SISO/SIPO)
        mode = 2'b01; s_in = 1; #10;
        s_in = 0; #10;

        // Shift right (PISO)
        mode = 2'b11; s_in = 1; #10;
        s_in = 1; #10;

        $finish;
    end

endmodule