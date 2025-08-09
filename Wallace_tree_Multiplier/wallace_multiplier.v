// Wallace Tree Multiplier - 4x4
module wallace_multiplier (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] product
);

    wire [3:0] pp0, pp1, pp2, pp3; // Partial products
    wire [7:0] sum1, carry1;
    wire [7:0] sum2, carry2;

    // Partial product generation
    assign pp0 = a & {4{b[0]}};
    assign pp1 = a & {4{b[1]}};
    assign pp2 = a & {4{b[2]}};
    assign pp3 = a & {4{b[3]}};

    // First addition stage
    assign {carry1[0], sum1[0]} = {1'b0, pp0[0]};
    assign {carry1[1], sum1[1]} = pp0[1] + pp1[0];
    assign {carry1[2], sum1[2]} = pp0[2] + pp1[1] + pp2[0];
    assign {carry1[3], sum1[3]} = pp0[3] + pp1[2] + pp2[1] + pp3[0];
    assign {carry1[4], sum1[4]} = pp1[3] + pp2[2] + pp3[1];
    assign {carry1[5], sum1[5]} = pp2[3] + pp3[2];
    assign {carry1[6], sum1[6]} = pp3[3];
    assign carry1[7] = 1'b0;

    // Second addition stage (carry propagate)
    assign {carry2[0], sum2[0]} = {1'b0, sum1[0]};
    assign {carry2[1], sum2[1]} = sum1[1] + carry1[0];
    assign {carry2[2], sum2[2]} = sum1[2] + carry1[1];
    assign {carry2[3], sum2[3]} = sum1[3] + carry1[2];
    assign {carry2[4], sum2[4]} = sum1[4] + carry1[3];
    assign {carry2[5], sum2[5]} = sum1[5] + carry1[4];
    assign {carry2[6], sum2[6]} = sum1[6] + carry1[5];
    assign {carry2[7], sum2[7]} = carry1[6];

    // Final sum
    assign product = sum2 + (carry2 << 1);

endmodule