// Clock Gating Circuit – Power-saving control logic

module clock_gating (
    input  wire clk,      // Original clock
    input  wire en,       // Enable signal
    output wire gated_clk // Gated clock output
);

    // Simple clock gating: AND clock with enable
    // In practice, latch-based gating is preferred to avoid glitches.
    assign gated_clk = clk & en;

endmodule