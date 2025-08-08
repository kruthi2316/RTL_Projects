// 4-bit Gray Code Counter
module gray_counter_4bit (
    input wire clk,
    input wire rst,
    output reg [3:0] gray
);

    reg [3:0] binary;

    initial begin
        binary = 4'b0000;
        gray = 4'b0000;
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            binary <= 4'b0000;
        else
            binary <= binary + 1;
    end

    // Binary to Gray Code conversion
    always @(*) begin
        gray = binary ^ (binary >> 1);
    end

endmodule