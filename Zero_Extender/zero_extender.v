// Zero Extender – 4-bit to 8-bit
module zero_extender (
    input wire [3:0] in,
    output wire [7:0] out
);

// Zero padding on upper 4 bits
assign out = {4'b0000, in};

endmodule