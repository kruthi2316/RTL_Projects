// Intentional buggy example module to test latch vs flop behavior

module latch_vs_flop (
    input wire clk,
    input wire en,
    input wire d,
    output reg q_latch,
    output reg q_flop
);

    // Latch: level-sensitive (this is BAD if unintended)
    always @(*) begin
        if (en)
            q_latch = d;  // Causes latch if not all conditions covered
        // else missing → latch inferred
    end

    // Flip-Flop: edge-triggered (correct)
    always @(posedge clk) begin
        if (en)
            q_flop <= d;
    end

endmodule