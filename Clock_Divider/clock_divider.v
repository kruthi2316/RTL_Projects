// Clock Divider by 4
module clock_divider (
    input wire clk,
    input wire rst,
    output reg clk_out
);

    reg [1:0] counter;

    initial begin
        counter = 2'b00;
        clk_out = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11)
                clk_out <= ~clk_out;
        end
    end

endmodule