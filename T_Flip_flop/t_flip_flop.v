module t_flip_flop (
    input wire clk,
    input wire t,
    output reg q
);
    initial q = 0; // This prevents X at start

    always @(posedge clk) begin
        if (t)
            q <= ~q;
    end
endmodule