// Watchdog Timer – Triggers reset on inactivity
module watchdog_timer (
    input wire clk,
    input wire rst,
    input wire kick,              // Reset the timer when high
    output reg wdt_reset          // System reset signal
);

parameter TIMEOUT = 10;          // Timeout threshold (in clock cycles)
reg [3:0] counter;               // 4-bit counter

always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
        wdt_reset <= 0;
    end
    else if (kick) begin
        counter <= 0;
        wdt_reset <= 0;
    end
    else begin
        counter <= counter + 1;
        if (counter >= TIMEOUT) begin
            wdt_reset <= 1;
        end
    end
end

endmodule