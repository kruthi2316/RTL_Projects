// JK Flip-Flop (Positive Edge-Triggered)
module jk_flip_flop (
    input wire clk,
    input wire j,
    input wire k,
    output reg q
);
    initial q = 0;

    always @(posedge clk) begin
        case ({j, k})
            2'b00: q <= q;         // No change
            2'b01: q <= 0;         // Reset
            2'b10: q <= 1;         // Set
            2'b11: q <= ~q;        // Toggle
        endcase
    end
endmodule