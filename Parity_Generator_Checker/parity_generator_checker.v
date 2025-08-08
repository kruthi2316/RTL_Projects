// Parity Generator and Checker
module parity_generator_checker (
    input wire [3:0] data,
    input wire parity_bit,
    input wire mode,             // 0 = generate, 1 = check
    output wire even_parity,
    output wire odd_parity,
    output wire parity_valid     // Only valid when mode = 1
);

wire even_gen, odd_gen;

assign even_gen = ~^data;  // Even parity: XOR of all bits, then NOT
assign odd_gen  =  ^data;  // Odd parity: XOR of all bits

assign even_parity = (mode == 0) ? even_gen : 1'bz;
assign odd_parity  = (mode == 0) ? odd_gen  : 1'bz;

assign parity_valid = (mode == 1) ? (parity_bit == even_gen) : 1'bz;

endmodule