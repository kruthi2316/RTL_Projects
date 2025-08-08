// 4-bit ALU with basic operations
module alu4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] sel,     // 3-bit operation select
    output reg  [3:0] result,
    output reg        carry,
    output reg        zero
);

always @(*) begin
    case (sel)
        3'b000: {carry, result} = a + b;       // Addition
        3'b001: {carry, result} = a - b;       // Subtraction
        3'b010: result = a & b;                // AND
        3'b011: result = a | b;                // OR
        3'b100: result = a ^ b;                // XOR
        3'b101: result = ~a;                   // NOT A
        3'b110: result = a << 1;               // Logical left shift
        3'b111: result = a >> 1;               // Logical right shift
        default: result = 4'b0000;
    endcase

    carry = (sel == 3'b000 || sel == 3'b001) ? carry : 0;
    zero = (result == 4'b0000) ? 1 : 0;
end

endmodule