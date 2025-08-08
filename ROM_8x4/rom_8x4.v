// 8x4 ROM (Read-Only Memory)

module rom_8x4 (
    input wire [2:0] addr,       // 3-bit Address (0 to 7)
    output reg [3:0] data_out    // 4-bit Data
);

    always @(*) begin
        case (addr)
            3'b000: data_out = 4'b0001;
            3'b001: data_out = 4'b0010;
            3'b010: data_out = 4'b0011;
            3'b011: data_out = 4'b0100;
            3'b100: data_out = 4'b1000;
            3'b101: data_out = 4'b1010;
            3'b110: data_out = 4'b1100;
            3'b111: data_out = 4'b1111;
            default: data_out = 4'b0000;
        endcase
    end

endmodule