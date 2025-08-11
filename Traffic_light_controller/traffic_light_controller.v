// Traffic Light Controller using FSM (3 states)
module traffic_light_controller (
    input wire clk,
    input wire rst,
    output reg [2:0] light
);

// Encoding lights: [2]=Red, [1]=Yellow, [0]=Green
// State encoding
parameter RED = 2'b00,
          GREEN = 2'b01,
          YELLOW = 2'b10;

reg [1:0] state, next_state;

// Counter for timing
reg [3:0] timer;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= RED;
        timer <= 0;
    end else begin
        if (state != next_state)
        timer <= 0;
        else
        timer <= timer + 1;
    state <= next_state;
    end
end

// Next state logic based on timer
always @(*) begin
    case (state)
        RED:    next_state = (timer == 4'd5) ? GREEN  : RED;
        GREEN:  next_state = (timer == 4'd5) ? YELLOW : GREEN;
        YELLOW: next_state = (timer == 4'd2) ? RED    : YELLOW;
        default: next_state = RED;
    endcase
end

// Output logic
always @(*) begin
    case (state)
        RED:    light = 3'b100; // Red ON
        GREEN:  light = 3'b001; // Green ON
        YELLOW: light = 3'b010; // Yellow ON
        default: light = 3'b000;
    endcase
end

endmodule