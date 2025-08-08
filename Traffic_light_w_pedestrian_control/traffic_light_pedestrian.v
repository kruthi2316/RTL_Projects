module traffic_light_pedestrian (
    input wire clk,
    input wire rst,
    input wire pedestrian_request,
    output reg [2:0] light,    // [2]=Red, [1]=Yellow, [0]=Green
    output reg walk            // 1 = Walk signal ON
);

parameter RED = 2'b00,
          GREEN = 2'b01,
          YELLOW = 2'b10,
          WALK = 2'b11;

reg [1:0] state, next_state;
reg [3:0] timer;

// FSM sequential logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= RED;
        timer <= 0;
        walk <= 0;
    end else begin
        state <= next_state;

        if (state != next_state)
            timer <= 0;
        else
            timer <= timer + 1;
    end
end

// FSM next-state logic
always @(*) begin
    next_state = state;

    case (state)
        RED: begin
            if (timer >= 4'd5) begin
                if (pedestrian_request)
                    next_state = WALK;
                else
                    next_state = GREEN;
            end
        end

        GREEN: begin
            if (timer >= 4'd5)
                next_state = YELLOW;
        end

        YELLOW: begin
            if (timer >= 4'd2)
                next_state = RED;
        end

        WALK: begin
            if (timer >= 4'd3)
                next_state = GREEN;
        end
    endcase
end

// Output logic
always @(*) begin
    light = 3'b000;
    walk = 0;

    case (state)
        RED:    light = 3'b100;
        GREEN:  light = 3'b001;
        YELLOW: light = 3'b010;
        WALK:   begin
            light = 3'b100; // Red light stays ON
            walk = 1;
        end
    endcase
end

endmodule