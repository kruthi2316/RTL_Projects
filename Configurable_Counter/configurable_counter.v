// 4-bit Configurable Counter with Load, Reset, and Hold
module configurable_counter (
    input wire clk,
    input wire rst,
    input wire load,
    input wire hold,
    input wire [3:0] load_value,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'd0;
    else if (load)
        count <= load_value;
    else if (hold)
        count <= count;  // No change
    else
        count <= count + 1;
end

endmodule