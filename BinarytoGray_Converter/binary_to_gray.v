// Binary to Gray Code Converter - 4-bit
module binary_to_gray (
    input wire [3:0] binary,
    output wire [3:0] gray
);

assign gray[3] = binary[3];                   // MSB remains same
assign gray[2] = binary[3] ^ binary[2];
assign gray[1] = binary[2] ^ binary[1];
assign gray[0] = binary[1] ^ binary[0];

endmodule