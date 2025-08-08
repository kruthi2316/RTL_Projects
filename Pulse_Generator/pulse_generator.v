// Pulse Generator – One-shot pulse on trigger
module pulse_generator (
    input wire clk,
    input wire rst,
    input wire trigger,
    output reg pulse
);

    reg trigger_d;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            trigger_d <= 0;
            pulse <= 0;
        end else begin
            trigger_d <= trigger;
            pulse <= trigger & ~trigger_d; // rising edge detector
        end
    end

endmodule