// 1011 Sequence Detector – Moore FSM (Verilog-2005 compliant)
module seq_detector_1011 (
    input wire clk,
    input wire rst,
    input wire in,
    output reg detected
);

    // State encoding
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100;

    reg [2:0] state, next_state;

    // State transition on clock
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            S0: next_state = (in == 1) ? S1 : S0;
            S1: next_state = (in == 0) ? S2 : S1;
            S2: next_state = (in == 1) ? S3 : S0;
            S3: next_state = (in == 1) ? S4 : S2;
            S4: next_state = (in == 1) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        detected = (state == S4);
    end

endmodule