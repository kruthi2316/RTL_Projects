// 8-bit Up/Down Counter - Synchronous
module updown_counter_8bit (
    input wire clk,
    input wire rst,
    input wire up_down,     // 1 for up, 0 for down
    output reg [7:0] count
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 8'b0;
        else begin
            if (up_down)
                count <= count + 1;
            else
                count <= count - 1;
        end
    end

endmodule