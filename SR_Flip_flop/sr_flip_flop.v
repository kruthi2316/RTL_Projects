// SR Flip-Flop (Positive Edge-Triggered)
module sr_flip_flop (
    input wire clk,
    input wire s,    // Set
    input wire r,    // Reset
    output reg q
);
    initial q = 0;

    always @(posedge clk) begin
        case ({s, r})
            2'b00: q <= q;       // No change
            2'b01: q <= 0;       // Reset
            2'b10: q <= 1;       // Set
            2'b11: q <= 1'bx;    // Invalid (both set and reset)
        endcase
    end
endmodule