// Time-Multiplexed 7-Segment Display Driver
// Drives four 7-segment displays by time multiplexing

module time_mux_7seg_driver(
    input wire clk,                // System clock
    input wire rst_n,              // Active low reset
    input wire [15:0] digits_bcd,  // 4 BCD digits to display (4 bits each)
    output reg [6:0] seg,          // 7-segment segments (a-g)
    output reg [3:0] digit_enable  // Digit enable signals (active low)
);

    reg [1:0] current_digit;
    reg [3:0] current_bcd;
    reg [16:0] refresh_counter;

    // 7-segment encoding for digits 0-9 (common cathode assumed)
    function [6:0] bcd_to_7seg;
        input [3:0] bcd;
        begin
            case (bcd)
                4'd0: bcd_to_7seg = 7'b1000000;
                4'd1: bcd_to_7seg = 7'b1111001;
                4'd2: bcd_to_7seg = 7'b0100100;
                4'd3: bcd_to_7seg = 7'b0110000;
                4'd4: bcd_to_7seg = 7'b0011001;
                4'd5: bcd_to_7seg = 7'b0010010;
                4'd6: bcd_to_7seg = 7'b0000010;
                4'd7: bcd_to_7seg = 7'b1111000;
                4'd8: bcd_to_7seg = 7'b0000000;
                4'd9: bcd_to_7seg = 7'b0010000;
                default: bcd_to_7seg = 7'b1111111; // blank
            endcase
        end
    endfunction

    // Refresh rate divider (~1kHz assuming 50MHz clk)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            refresh_counter <= 0;
            current_digit <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
            if (refresh_counter == 0) begin
                current_digit <= current_digit + 1;
            end
        end
    end

    // Select current BCD digit based on current_digit index
    always @(*) begin
        case (current_digit)
            2'd0: current_bcd = digits_bcd[3:0];
            2'd1: current_bcd = digits_bcd[7:4];
            2'd2: current_bcd = digits_bcd[11:8];
            2'd3: current_bcd = digits_bcd[15:12];
            default: current_bcd = 4'd0;
        endcase
    end

    // Drive segments and digit enable (active low)
    always @(*) begin
        seg = bcd_to_7seg(current_bcd);
        digit_enable = ~(4'b0001 << current_digit); // One digit active low
    end

endmodule
