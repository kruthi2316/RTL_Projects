// Pipelined Multiplier (parameterized N x N)
// Produces product after N pipeline stages; accepts new input every cycle when in_valid is asserted.
module pipelined_multiplier
#(
    parameter N = 4                     // Width of multiplicand and multiplier
)
(
    input  wire                  clk,
    input  wire                  rst,      // synchronous reset (active high)
    input  wire                  in_valid, // assert when a and b are valid this cycle
    input  wire [N-1:0]          a,
    input  wire [N-1:0]          b,
    output reg  [(2*N)-1:0]      product,
    output reg                   out_valid // high when 'product' is valid
);

    // Internal pipeline registers
    // sum_reg[i] holds partial sum after stage i (width 2N)
    reg [(2*N)-1:0] sum_reg [0:N];
    // a_pipe[i] holds operand a shifted left by i (width 2N so it can be added)
    reg [(2*N)-1:0] a_pipe [0:N];
    // b_pipe[i] holds the remaining multiplier bits; we will check bit 0 each stage
    reg [N-1:0] b_pipe [0:N];
    // valid pipeline to indicate when a result will appear
    reg valid_pipe [0:N];

    integer i;

    // synchronous pipeline update
    always @(posedge clk) begin
        if (rst) begin
            // clear pipeline
            for (i = 0; i <= N; i = i + 1) begin
                sum_reg[i] <= {(2*N){1'b0}};
                a_pipe[i] <= {(2*N){1'b0}};
                b_pipe[i] <= {N{1'b0}};
                valid_pipe[i] <= 1'b0;
            end
            product <= {(2*N){1'b0}};
            out_valid <= 1'b0;
        end else begin
            // Stage 0 load new operands when in_valid
            if (in_valid) begin
                sum_reg[0] <= {(2*N){1'b0}};       // initial partial sum = 0
                // place a in lower N bits of a_pipe[0] (no left shift yet)
                a_pipe[0] <= {{(2*N - N){1'b0}}, a};
                b_pipe[0] <= b;
                valid_pipe[0] <= 1'b1;
            end else begin
                // if not valid input, stage0 gets zeros and invalid
                sum_reg[0] <= {(2*N){1'b0}};
                a_pipe[0] <= {(2*N){1'b0}};
                b_pipe[0] <= {N{1'b0}};
                valid_pipe[0] <= 1'b0;
            end

            // propagate through pipeline stages
            for (i = 0; i < N; i = i + 1) begin
                // compute addition for stage i:
                // if LSB of b_pipe[i] is 1, add a_pipe[i] to sum_reg[i]
                if (b_pipe[i][0]) begin
                    sum_reg[i+1] <= sum_reg[i] + a_pipe[i];
                end else begin
                    sum_reg[i+1] <= sum_reg[i];
                end

                // shift a left by 1 for next stage (so at stage j it represents a << j)
                a_pipe[i+1] <= a_pipe[i] << 1;

                // shift b right by 1 for next stage so next stage checks next bit in LSB
                b_pipe[i+1] <= b_pipe[i] >> 1;

                // propagate validity
                valid_pipe[i+1] <= valid_pipe[i];
            end

            // output from last stage
            product <= sum_reg[N];
            out_valid <= valid_pipe[N];
        end
    end

endmodule