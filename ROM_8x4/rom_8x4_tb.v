// Testbench for 8x4 ROM
`timescale 1ns/1ps

module rom_8x4_tb;

    reg [2:0] addr;
    wire [3:0] data_out;

    // Instantiate DUT
    rom_8x4 uut (
        .addr(addr),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("rom_8x4.vcd");
        $dumpvars(0, rom_8x4_tb);

        // Test all addresses from 0 to 7
        addr = 3'b000; #10;
        addr = 3'b001; #10;
        addr = 3'b010; #10;
        addr = 3'b011; #10;
        addr = 3'b100; #10;
        addr = 3'b101; #10;
        addr = 3'b110; #10;
        addr = 3'b111; #10;

        $finish;
    end

endmodule