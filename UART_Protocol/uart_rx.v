module uart_rx
#(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)
(
    input clk,
    input reset,
    input rx_serial,
    output reg [7:0] rx_data,
    output reg rx_ready,
    output reg rx_error
);

    localparam integer BAUD_DIV   = CLK_FREQ / BAUD_RATE;
    localparam integer HALF_BAUD  = BAUD_DIV / 2;

    reg [1:0] state = 0; // 0=IDLE, 1=START, 2=DATA, 3=STOP
    reg [15:0] baud_counter = 0;
    reg [3:0] bit_index = 0;
    reg [7:0] data_shift = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            baud_counter <= 0;
            bit_index <= 0;
            rx_ready <= 0;
            rx_error <= 0;
            rx_data <= 8'b0;
            data_shift <= 0;
        end else begin
            rx_ready <= 0; // Clear flag every cycle unless new data

            case(state)
                0: begin // IDLE
                    rx_error <= 0;
                    if (rx_serial == 0) begin // Start bit detect
                        baud_counter <= HALF_BAUD;
                        state <= 1;
                    end
                end

                1: begin // START
                    if (baud_counter == 0) begin
                        if (rx_serial == 0) begin
                            baud_counter <= BAUD_DIV - 1;
                            bit_index <= 0;
                            state <= 2;
                        end else
                            state <= 0; // False start
                    end else
                        baud_counter <= baud_counter - 1;
                end

                2: begin // DATA
                    if (baud_counter == 0) begin
                        data_shift <= {rx_serial, data_shift[7:1]};
                        baud_counter <= BAUD_DIV - 1;
                        if (bit_index == 7)
                            state <= 3;
                        else
                            bit_index <= bit_index + 1;
                    end else
                        baud_counter <= baud_counter - 1;
                end

                3: begin // STOP
                    if (baud_counter == 0) begin
                        if (rx_serial == 1) begin
                            rx_data <= data_shift;
                            rx_ready <= 1;
                            rx_error <= 0;
                        end else
                            rx_error <= 1;
                        state <= 0;
                    end else
                        baud_counter <= baud_counter - 1;
                end
            endcase
        end
    end
endmodule