// 4-bit Ring Counter
module ring_counter (
    input wire clk,
    input wire rst,
    output reg [3:0] q
);
    initial q = 4'b0001;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0001;  // Initial value
        else
            q <= {q[2:0], q[3]}; // Rotate left
    end
endmodule