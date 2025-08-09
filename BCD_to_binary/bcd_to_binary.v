// BCD to Binary Converter- Converts 4-digit BCD (16 bits) input to 14-bit binary output

module bcd_to_binary (
    input wire [15:0] bcd,       // 4 BCD digits (each 4 bits)
    output reg [13:0] binary     // Binary equivalent (max 9999 decimal fits in 14 bits)
);

    always @(*) begin
        binary = (bcd[3:0]) + 
                 (bcd[7:4] * 4'd10) + 
                 (bcd[11:8] * 7'd100) + 
                 (bcd[15:12] * 10'd1000);
    end

endmodule