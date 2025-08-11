// 4-bit ALU with Flag Outputs: Carry, Zero, Overflow

module alu_with_flags (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [2:0] op,            // Operation selector
    output reg [3:0] result,
    output reg carry,
    output reg zero,
    output reg overflow
);

    reg [4:0] temp; // 1 extra bit for carry

    always @(*) begin
        carry = 0;
        overflow = 0;

        case (op)
            3'b000: temp = a + b;                    // ADD
            3'b001: temp = a - b;                    // SUB
            3'b010: temp = a & b;                    // AND
            3'b011: temp = a | b;                    // OR
            3'b100: temp = a ^ b;                    // XOR
            3'b101: temp = ~a;                       // NOT A
            3'b110: temp = a << 1;                   // Shift Left
            3'b111: temp = a >> 1;                   // Shift Right
            default: temp = 5'b00000;
        endcase

        result = temp[3:0];
        carry = temp[4];                             // Carry flag

        // Zero flag
        zero = (result == 4'b0000);

        // Overflow flag (only valid for ADD/SUB)
        if (op == 3'b000) begin
            overflow = (~a[3] & ~b[3] & result[3]) | (a[3] & b[3] & ~result[3]);
        end else if (op == 3'b001) begin
            overflow = (~a[3] & b[3] & result[3]) | (a[3] & ~b[3] & ~result[3]);
        end
    end

endmodule