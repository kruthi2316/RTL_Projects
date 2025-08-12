// memory_controller.v
// Clean variable names and simplified formatting

module memory_controller #(
    parameter DATA_WIDTH    = 8,
    parameter ADDR_WIDTH    = 16,
    parameter MEM_BASE_ADDR = 16'h1000,
    parameter MEM_ADDR_BITS = 11  // 2^11 = 2048 locations
) (
    // System Signals
    input                       clk,
    input                       reset_n,

    // CPU Interface
    input      [ADDR_WIDTH-1:0] cpu_addr,
    input      [DATA_WIDTH-1:0] cpu_write_data,
    input                       cpu_read_en,
    input                       cpu_write_en,
    output reg [DATA_WIDTH-1:0] cpu_read_data,
    output reg                  cpu_ready,

    // Memory Interface
    input      [DATA_WIDTH-1:0] mem_read_data,
    output     [MEM_ADDR_BITS-1:0] mem_addr,
    output     [DATA_WIDTH-1:0] mem_write_data,
    output reg                  mem_write_en,
    output reg                  mem_chip_en
);

    // State machine
    localparam [1:0] IDLE       = 2'b00,
                     WRITE_CYCLE = 2'b01,
                     READ_SETUP  = 2'b10,
                     READ_WAIT   = 2'b11;

    reg [1:0] state, next_state;

    // Address check
    wire addr_valid = (cpu_addr >= MEM_BASE_ADDR) && 
                      (cpu_addr < (MEM_BASE_ADDR + (1 << MEM_ADDR_BITS)));

    // Map CPU address to memory address
    assign mem_addr       = cpu_addr[MEM_ADDR_BITS-1:0];
    assign mem_write_data = cpu_write_data;

    // Next state and output logic
    always @(*) begin
        next_state   = state;
        cpu_ready    = 1'b0;
        mem_chip_en  = 1'b0;
        mem_write_en = 1'b0;

        case (state)
            IDLE: begin
                if (addr_valid) begin
                    if (cpu_write_en) begin
                        next_state = WRITE_CYCLE;
                    end else if (cpu_read_en) begin
                        next_state = READ_SETUP;
                    end
                end
            end

            WRITE_CYCLE: begin
                mem_chip_en  = 1'b1;
                mem_write_en = 1'b1;
                cpu_ready    = 1'b1;
                next_state   = IDLE;
            end

            READ_SETUP: begin
                mem_chip_en  = 1'b1;
                mem_write_en = 1'b0;
                next_state   = READ_WAIT;
            end

            READ_WAIT: begin
                mem_chip_en  = 1'b1;
                cpu_ready    = 1'b1;
                next_state   = IDLE;
            end
        endcase
    end

    // Sequential logic
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state         <= IDLE;
            cpu_read_data <= 0;
        end else begin
            state <= next_state;
            if (state == READ_WAIT) begin
                cpu_read_data <= mem_read_data;
            end
        end
    end

endmodule