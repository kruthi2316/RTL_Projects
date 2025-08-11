`timescale 1ns / 1ps

module dma_controller #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter MEM_DEPTH  = 256
)(
    input                     clk,
    input                     rst_n,

    // Channel 0 inputs
    input                     ch0_start,
    input  [ADDR_WIDTH-1:0]   ch0_src,
    input  [ADDR_WIDTH-1:0]   ch0_dst,
    input  [7:0]              ch0_size,

    // Channel 1 inputs
    input                     ch1_start,
    input  [ADDR_WIDTH-1:0]   ch1_src,
    input  [ADDR_WIDTH-1:0]   ch1_dst,
    input  [7:0]              ch1_size,

    // Memory interface
    output reg                mem_read_en,
    output reg                mem_write_en,
    output reg [ADDR_WIDTH-1:0] mem_addr,
    output reg [DATA_WIDTH-1:0] mem_write_data,
    input      [DATA_WIDTH-1:0] mem_read_data,

    // Channel done outputs
    output reg                ch0_done,
    output reg                ch1_done
);

localparam IDLE      = 3'd0;
localparam CH0_READ  = 3'd1;
localparam CH0_WRITE = 3'd2;
localparam CH1_READ  = 3'd3;
localparam CH1_WRITE = 3'd4;
localparam DONE      = 3'd5;

reg [2:0] state, next_state;

reg [ADDR_WIDTH-1:0] src_addr_r, dst_addr_r;
reg [7:0] size_r;
reg [7:0] count;

reg current_channel; // 0 or 1

// Latch inputs on start rising edge
reg ch0_start_r, ch1_start_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ch0_start_r <= 0;
        ch1_start_r <= 0;
    end else begin
        ch0_start_r <= ch0_start;
        ch1_start_r <= ch1_start;
    end
end

wire ch0_start_pulse = ch0_start & ~ch0_start_r;
wire ch1_start_pulse = ch1_start & ~ch1_start_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        mem_read_en <= 0;
        mem_write_en <= 0;
        mem_addr <= 0;
        mem_write_data <= 0;
        ch0_done <= 0;
        ch1_done <= 0;
        src_addr_r <= 0;
        dst_addr_r <= 0;
        size_r <= 0;
        count <= 0;
        current_channel <= 0;
    end else begin
        state <= next_state;

        // Default signals
        mem_read_en <= 0;
        mem_write_en <= 0;
        ch0_done <= 0;
        ch1_done <= 0;

        case (state)
            IDLE: begin
                $display("[%0t] State: IDLE", $time);
                if (ch0_start_pulse && ch0_size != 0) begin
                    src_addr_r <= ch0_src;
                    dst_addr_r <= ch0_dst;
                    size_r <= ch0_size;
                    count <= 0;
                    current_channel <= 0;
                end else if (ch1_start_pulse && ch1_size != 0) begin
                    src_addr_r <= ch1_src;
                    dst_addr_r <= ch1_dst;
                    size_r <= ch1_size;
                    count <= 0;
                    current_channel <= 1;
                end
            end

            CH0_READ, CH1_READ: begin
                $display("[%0t] State: MEM_READ ch=%0d, src=%0d, dst=%0d, count=%0d, size=%0d", $time, current_channel, src_addr_r, dst_addr_r, count, size_r);
                mem_read_en <= 1;
                mem_addr <= src_addr_r + count;
            end

            CH0_WRITE, CH1_WRITE: begin
                $display("[%0t] State: MEM_WRITE ch=%0d, src=%0d, dst=%0d, count=%0d, size=%0d, data=0x%0h", $time, current_channel, src_addr_r, dst_addr_r, count, size_r, mem_read_data);
                mem_write_en <= 1;
                mem_addr <= dst_addr_r + count;
                mem_write_data <= mem_read_data;
            end

            DONE: begin
                $display("[%0t] State: DONE ch=%0d", $time, current_channel);
                if (current_channel == 0)
                    ch0_done <= 1;
                else
                    ch1_done <= 1;
            end
        endcase
    end
end

// Next state logic
always @(*) begin
    next_state = state;

    case (state)
        IDLE: begin
            if (ch0_start_pulse && ch0_size != 0)
                next_state = CH0_READ;
            else if (ch1_start_pulse && ch1_size != 0)
                next_state = CH1_READ;
        end

        CH0_READ: next_state = CH0_WRITE;
        CH0_WRITE: begin
            if (count == size_r - 1)
                next_state = DONE;
            else
                next_state = CH0_READ;
        end

        CH1_READ: next_state = CH1_WRITE;
        CH1_WRITE: begin
            if (count == size_r - 1)
                next_state = DONE;
            else
                next_state = CH1_READ;
        end

        DONE: next_state = IDLE;
    endcase
end

// Count increments on read or write states
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        count <= 0;
    end else begin
        if ((state == CH0_READ || state == CH0_WRITE || state == CH1_READ || state == CH1_WRITE) && (next_state != state)) begin
            count <= count + 1;
        end else if (next_state == IDLE) begin
            count <= 0;
        end
    end
end

endmodule