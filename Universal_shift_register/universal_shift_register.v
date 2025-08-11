// Universal 4-bit Shift Register (SISO, SIPO, PISO, PIPO)

module universal_shift_register (
    input wire clk,
    input wire rst,
    input wire [1:0] mode,      // 00: Hold, 01: Shift Left, 10: Load Parallel, 11: Shift Right
    input wire s_in,            // Serial Input
    input wire [3:0] p_in,      // Parallel Input
    output wire s_out,          // Serial Output (MSB)
    output wire [3:0] p_out     // Parallel Output
);

    reg [3:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            shift_reg <= 4'b0000;
        else begin
            case (mode)
                2'b00: shift_reg <= shift_reg;                          // Hold
                2'b01: shift_reg <= {shift_reg[2:0], s_in};            // Shift Left (SISO/SIPO)
                2'b10: shift_reg <= p_in;                               // Load Parallel (PIPO)
                2'b11: shift_reg <= {s_in, shift_reg[3:1]};            // Shift Right (PISO)
            endcase
        end
    end

    assign s_out = shift_reg[3];  // Serial Output (MSB)
    assign p_out = shift_reg;     // Parallel Output

endmodule