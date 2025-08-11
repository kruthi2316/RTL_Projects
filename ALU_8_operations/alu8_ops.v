// ALU with 8 Operations (parameterizable width) and Flag Outputs
// Level 2 RTL: supports signed overflow detection, carry/borrow, zero, negative

module alu8_ops #(
    parameter WIDTH = 8   // data width (default 8-bit)
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire [2:0]       op,     // opcode selects operation
    output reg  [WIDTH-1:0] result,
    output reg              flag_c, // Carry (unsigned carry-out / borrow semantics described in README)
    output reg              flag_z, // Zero (result == 0)
    output reg              flag_v, // Overflow (signed)
    output reg              flag_n  // Negative (result MSB for signed)
);

    // Local wide temporary to hold extra bit for carry/borrow
    reg [WIDTH:0] temp;

    always @(*) begin
        // default flags
        flag_c = 1'b0;
        flag_v = 1'b0;
        result = {WIDTH{1'b0}};
        temp = { (WIDTH+1){1'b0} };

        case (op)
            3'b000: begin
                // ADD: a + b
                temp = {1'b0, a} + {1'b0, b};
                result = temp[WIDTH-1:0];
                flag_c = temp[WIDTH]; // carry-out
                // signed overflow: when signs of a and b same and differ from result sign
                flag_v = (a[WIDTH-1] & b[WIDTH-1] & ~result[WIDTH-1]) |
                         (~a[WIDTH-1] & ~b[WIDTH-1] & result[WIDTH-1]);
            end

            3'b001: begin
                // SUB: a - b
                temp = {1'b0, a} - {1'b0, b};
                result = temp[WIDTH-1:0];
                // For subtraction, temp[WIDTH] == 1 indicates borrow (a < b).
                // We set flag_c = ~borrow so that flag_c == 1 when a >= b (unsigned no-borrow).
                flag_c = ~temp[WIDTH];
                // signed overflow for subtraction: a - b overflows when signs of a and b differ
                // and sign of result differs from sign of a.
                flag_v = (a[WIDTH-1] & ~b[WIDTH-1] & ~result[WIDTH-1]) |
                         (~a[WIDTH-1] & b[WIDTH-1] & result[WIDTH-1]);
            end

            3'b010: begin
                // AND
                result = a & b;
                flag_c = 1'b0;
                flag_v = 1'b0;
            end

            3'b011: begin
                // OR
                result = a | b;
                flag_c = 1'b0;
                flag_v = 1'b0;
            end

            3'b100: begin
                // XOR
                result = a ^ b;
                flag_c = 1'b0;
                flag_v = 1'b0;
            end

            3'b101: begin
                // NOT (on A)
                result = ~a;
                flag_c = 1'b0;
                flag_v = 1'b0;
            end

            3'b110: begin
                // Shift Left Logical by 1
                temp = {1'b0, a} << 1;
                result = temp[WIDTH-1:0];
                flag_c = temp[WIDTH]; // bit shifted out becomes carry
                flag_v = 1'b0;
            end

            3'b111: begin
                // Shift Right Logical by 1
                result = a >> 1;
                // For logical right shift, set carry = LSB that was shifted out
                flag_c = a[0];
                flag_v = 1'b0;
            end

            default: begin
                result = {WIDTH{1'b0}};
                flag_c = 1'b0;
                flag_v = 1'b0;
            end
        endcase

        // Zero flag
        flag_z = (result == {WIDTH{1'b0}});

        // Negative flag: MSB (signed)
        flag_n = result[WIDTH-1];
    end

endmodule