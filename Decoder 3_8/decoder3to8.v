// 3:8 Decoder
module decoder3to8 (
    input wire [2:0] in,
    input wire en,
    output wire [7:0] out
);
    assign out = (en == 1'b1) ? (8'b00000001 << in) : 8'b00000000;
endmodule