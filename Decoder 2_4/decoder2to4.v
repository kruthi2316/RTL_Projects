// 2:4 Decoder
module decoder2to4 (
    input wire [1:0] in,
    input wire en,
    output wire [3:0] out
);
    assign out = (en == 1'b1) ? (4'b0001 << in) : 4'b0000;
endmodule