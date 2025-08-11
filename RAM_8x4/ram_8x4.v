// 8x4 RAM (Read-Write Memory)

module ram_8x4 (
    input wire clk,
    input wire en,               // Write Enable: 1 = Write, 0 = Read
    input wire [2:0] addr,       // 3-bit Address (0 to 7)
    input wire [3:0] data_in,    // 4-bit Data Input
    output reg [3:0] data_out    // 4-bit Data Output
);

    reg [3:0] memory [7:0]; // 8 words of 4 bits

    always @(posedge clk) begin
        if (en) begin
            memory[addr] <= data_in;    // Write operation
        end else begin
            data_out <= memory[addr];   // Read operation
        end
    end

endmodule