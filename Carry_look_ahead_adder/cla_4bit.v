// 4-bit Carry Lookahead Adder (CLA)
module cla_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire cin,
    output wire [3:0] sum,
    output wire cout
);
    wire [3:0] g, p;   // Generate and Propagate
    wire [3:0] c;      // Carry bits

    // Generate and Propagate terms
    assign g = a & b;         // Generate
    assign p = a ^ b;         // Propagate

    // Carry Lookahead Logic
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign cout = g[3] | (p[3] & c[3]);

    // Sum calculation
    assign sum = p ^ c;

endmodule