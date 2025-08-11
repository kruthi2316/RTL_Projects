// 4-bit Johnson Counter
module johnson_counter (
    input wire clk,
    input wire rst,
    output reg [3:0] q
);
    initial q = 4'b0000;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0000;
        else
            q <= {~q[0], q[3:1]};
    end
endmodule