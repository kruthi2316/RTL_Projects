// i2c_master.v
// Simple I2C Master implementation 
module i2c_master(
    input             clk,          // System clock
    input             rst_n,        // Active-low reset
    input             start,        // Pulse to start transaction
    input      [6:0]  slave_addr,   // 7-bit slave address
    input      [7:0]  data_byte,    // Data byte to write

    output            busy,         // High when transaction is active
    inout             sda,          // I2C data line (open-drain)
    inout             scl           // I2C clock line
);

parameter CLK_DIVIDER = 250; // Clock divider for SCL frequency

// FSM States
parameter IDLE       = 3'b000;
parameter START_COND = 3'b001;
parameter SEND_BYTE  = 3'b010;
parameter WAIT_ACK   = 3'b011;
parameter STOP_COND  = 3'b100;

reg [2:0] state, next_state;

reg [8:0] clk_count;    // Clock divider counter
reg [3:0] bit_count;    // Bit counter (0 to 8)
reg [7:0] shift_reg;    // Data shift register
reg       is_addr_phase; // Flag for address or data phase
reg       scl_reg;
reg       sda_reg;
reg       sda_enable;

assign sda = sda_enable ? sda_reg : 1'bz; // Open-drain SDA
assign scl = scl_reg;
assign busy = (state != IDLE);

always @(*) begin
    // Defaults
    next_state = state;
    scl_reg = scl;
    sda_reg = sda;
    sda_enable = 1'b1;

    case (state)
        IDLE: begin
            scl_reg = 1'b1;
            sda_reg = 1'b1;
            if (start) next_state = START_COND;
        end

        START_COND: begin
            sda_reg = 1'b0; // Start condition: SDA goes low while SCL is high
            if (clk_count == CLK_DIVIDER) begin
                scl_reg = 1'b0; // Pull SCL low to start sending bits
                next_state = SEND_BYTE;
            end
        end

        SEND_BYTE: begin
            scl_reg = (clk_count < CLK_DIVIDER/2);
            sda_reg = shift_reg[7]; // Send MSB first

            if (clk_count == CLK_DIVIDER && bit_count == 8) begin
                next_state = WAIT_ACK;
            end
        end

        WAIT_ACK: begin
            sda_enable = 1'b0; // Release SDA for slave ACK bit
            scl_reg = (clk_count < CLK_DIVIDER/2);
            if (clk_count == CLK_DIVIDER) begin
                if (is_addr_phase)
                    next_state = SEND_BYTE; // Send data after address ACK
                else
                    next_state = STOP_COND; // Stop condition after data ACK
            end
        end

        STOP_COND: begin
            scl_reg = 1'b1;
            sda_reg = 1'b0;
            if (clk_count == CLK_DIVIDER) begin
                sda_reg = 1'b1; // Stop condition: SDA goes high while SCL high
                next_state = IDLE;
            end
        end

        default: next_state = IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        clk_count <= 0;
        bit_count <= 0;
        shift_reg <= 0;
        is_addr_phase <= 1'b1;
    end else begin
        state <= next_state;

        if (clk_count == CLK_DIVIDER)
            clk_count <= 0;
        else if (state != IDLE)
            clk_count <= clk_count + 1;

        if (state != next_state) begin
            clk_count <= 0;
            bit_count <= 0;

            // Fix: Load data depending on the previous state
            if (next_state == SEND_BYTE) begin
                if (state == START_COND) begin
                    // Load slave address + write bit (0)
                    shift_reg <= {slave_addr, 1'b0};
                    is_addr_phase <= 1'b1;
                end else if (state == WAIT_ACK) begin
                    // Load data byte after address ACK
                    shift_reg <= data_byte;
                    is_addr_phase <= 1'b0;
                end
            end
        end

        if (state == SEND_BYTE && clk_count == CLK_DIVIDER) begin
            shift_reg <= shift_reg << 1;
            bit_count <= bit_count + 1;
        end

        if (next_state == IDLE) begin
            is_addr_phase <= 1'b1;
        end
    end
end

endmodule