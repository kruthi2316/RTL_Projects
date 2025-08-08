`timescale 1ns/1ps

module parity_generator_checker_tb;

    reg [3:0] data;
    reg parity_bit;
    reg mode;
    wire even_parity, odd_parity, parity_valid;

    parity_generator_checker uut (
        .data(data),
        .parity_bit(parity_bit),
        .mode(mode),
        .even_parity(even_parity),
        .odd_parity(odd_parity),
        .parity_valid(parity_valid)
    );

    initial begin
        $dumpfile("parity_generator_checker.vcd");
        $dumpvars(0, parity_generator_checker_tb);

        // Generation Mode
        mode = 0;
        data = 4'b1011; #10;
        data = 4'b1111; #10;

        // Checking Mode
        mode = 1;
        data = 4'b1011; parity_bit = 1; #10;  // Should be valid
        data = 4'b1011; parity_bit = 0; #10;  // Should be invalid

        $finish;
    end

endmodule