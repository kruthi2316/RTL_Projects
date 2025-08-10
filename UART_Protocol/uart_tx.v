module uart_tx
#(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)
(
    input       clk,
    input       reset,
    input       tx_start,
    input [7:0] tx_data,
    output reg  tx_busy,
    output reg  tx_serial
);

    localparam integer BAUD_DIV = CLK_FREQ / BAUD_RATE;

    reg [15:0] baud_counter = 0;
    reg [3:0]  bit_index = 0;
    reg [9:0]  shift_reg = 10'b1111111111;
    reg [1:0]  state = 0; // 0=IDLE, 1=START, 2=DATA, 3=STOP

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_serial <= 1'b1;
            tx_busy <= 0;
            baud_counter <= 0;
            bit_index <= 0;
            shift_reg <= 10'b1111111111;
            state <= 0;
        end else begin
            case(state)
                0: begin // IDLE
                    tx_serial <= 1'b1;
                    tx_busy <= 0;
                    baud_counter <= 0;
                    bit_index <= 0;
                    if (tx_start) begin
                        shift_reg <= {1'b1, tx_data, 1'b0}; // stop, data, start
                        tx_busy <= 1;
                        state <= 1;
                    end
                end

                1: begin // START
                    if (baud_counter == BAUD_DIV - 1) begin
                        baud_counter <= 0;
                        tx_serial <= shift_reg[0];
                        shift_reg <= {1'b1, shift_reg[9:1]};
                        bit_index <= bit_index + 1;
                        state <= 2;
                    end else
                        baud_counter <= baud_counter + 1;
                end

                2: begin // DATA
                    if (baud_counter == BAUD_DIV - 1) begin
                        baud_counter <= 0;
                        tx_serial <= shift_reg[0];
                        shift_reg <= {1'b1, shift_reg[9:1]};
                        bit_index <= bit_index + 1;
                        if (bit_index == 8)
                            state <= 3;
                    end else
                        baud_counter <= baud_counter + 1;
                end

                3: begin // STOP
                    if (baud_counter == BAUD_DIV - 1) begin
                        baud_counter <= 0;
                        tx_serial <= 1'b1;
                        tx_busy <= 0;
                        state <= 0;
                    end else
                        baud_counter <= baud_counter + 1;
                end
            endcase
        end
    end
endmodule