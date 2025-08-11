// Sign Extender – 4-bit to 8-bit
module sign_extender (
    input wire [3:0] in,
    output wire [7:0] out
);

// Replicate the MSB (sign bit) 4 times and concatenate
assign out = {{4{in[3]}}, in};

endmodule