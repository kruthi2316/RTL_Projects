// spi_master.v
// Parameterizable SPI master (supports CPOL/CPHA modes 0..3)
// Single-byte transfers (DATA_WIDTH), simple start/done handshake.

`timescale 1ns/1ps
module spi_master #(
    parameter DATA_WIDTH = 8
)(
    input  wire                      clk,
    input  wire                      rst,      // synchronous active-high
    input  wire                      start,    // pulse to begin transfer (1 cycle)
    input  wire [DATA_WIDTH-1:0]     tx_byte,
    input  wire                      miso,     // from slave
    output reg  [DATA_WIDTH-1:0]     rx_byte,
    output reg                       busy,
    output reg                       done,     // one-cycle pulse when byte complete
    output reg                       sclk,
    output reg                       mosi,
    output reg                       ss_n,     // active low
    input  wire                      cpol,
    input  wire                      cpha,
    input  wire [15:0]               clk_div   // half SCLK period in system clk cycles, >=1
);
    // internal
    reg [15:0] half_cnt;
    integer    bit_idx;              // current bit index (msb -> lsb)
    reg [DATA_WIDTH-1:0] tx_shift;
    reg [DATA_WIDTH-1:0] rx_shift;
    reg running;

    // Map CPOL to leading/trailing edges:
    // if CPOL==0 -> leading = posedge sclk, trailing = negedge sclk
    // if CPOL==1 -> leading = negedge sclk, trailing = posedge sclk

    // Initialize
    always @(posedge clk) begin
        if (rst) begin
            sclk <= cpol;
            ss_n <= 1'b1;
            mosi <= 1'b0;
            busy <= 1'b0;
            done <= 1'b0;
            half_cnt <= 16'd0;
            running <= 1'b0;
            rx_byte <= {DATA_WIDTH{1'b0}};
        end else begin
            done <= 1'b0;
            if (!running) begin
                sclk <= cpol;
                half_cnt <= 16'd0;
                if (start) begin
                    // start transfer
                    ss_n <= 1'b0;
                    busy <= 1'b1;
                    running <= 1'b1;
                    tx_shift <= tx_byte;
                    rx_shift <= {DATA_WIDTH{1'b0}};
                    bit_idx <= DATA_WIDTH - 1;
                    // For CPHA==0, present first MOSI bit before first leading edge
                    if (cpha == 1'b0) begin
                        mosi <= tx_byte[DATA_WIDTH-1];
                    end else begin
                        mosi <= 1'b0; // will be set on first leading
                    end
                end else begin
                    busy <= 1'b0;
                    ss_n <= 1'b1;
                end
            end else begin
                // running -> generate sclk
                if (half_cnt + 1 >= clk_div) begin
                    half_cnt <= 16'd0;
                    sclk <= ~sclk;
                    // handle events on the new sclk level via separate conditional blocks below
                end else begin
                    half_cnt <= half_cnt + 1;
                end
            end
        end
    end

    // Handle actions at posedge and negedge of internal sclk
    // Use separate always blocks to be explicit and synthesizable.
    // posedge block:
    always @(posedge sclk) begin
        if (!rst && running) begin
            // Determine whether this posedge corresponds to leading or trailing
            if (cpol == 1'b0) begin
                // CPOL=0 -> posedge is leading
                if (cpha == 1'b0) begin
                    // sample on leading
                    rx_shift[bit_idx] <= miso;
                    // no decrement here; decrement happens on trailing for CPHA=0
                end else begin
                    // CPHA=1 -> on leading shift out next MOSI (present current bit)
                    mosi <= tx_shift[bit_idx];
                end
            end else begin
                // CPOL=1 -> posedge is trailing
                if (cpha == 1'b0) begin
                    // CPHA=0: trailing -> move to next bit (after leading sampled)
                    if (bit_idx == 0) begin
                        // last bit was already sampled on the previous leading
                        rx_byte <= rx_shift;
                        running <= 1'b0;
                        busy <= 1'b0;
                        done <= 1'b1;
                        ss_n <= 1'b1;
                        // restore idle sclk (set to cpol)
                        sclk <= cpol;
                    end else begin
                        bit_idx <= bit_idx - 1;
                        mosi <= tx_shift[bit_idx-1];
                    end
                end else begin
                    // CPHA=1: trailing -> sample
                    rx_shift[bit_idx] <= miso;
                    if (bit_idx == 0) begin
                        rx_byte <= rx_shift;
                        running <= 1'b0;
                        busy <= 1'b0;
                        done <= 1'b1;
                        ss_n <= 1'b1;
                        sclk <= cpol;
                    end else begin
                        bit_idx <= bit_idx - 1;
                    end
                end
            end
        end
    end

    // negedge block:
    always @(negedge sclk) begin
        if (!rst && running) begin
            // Determine whether this negedge corresponds to leading or trailing
            if (cpol == 1'b0) begin
                // CPOL=0 -> negedge is trailing
                if (cpha == 1'b0) begin
                    // CPHA=0: trailing -> move to next bit
                    if (bit_idx == 0) begin
                        // last bit already sampled on leading; finish
                        rx_byte <= rx_shift;
                        running <= 1'b0;
                        busy <= 1'b0;
                        done <= 1'b1;
                        ss_n <= 1'b1;
                        sclk <= cpol;
                    end else begin
                        bit_idx <= bit_idx - 1;
                        mosi <= tx_shift[bit_idx-1];
                    end
                end else begin
                    // CPHA=1: trailing -> sample
                    rx_shift[bit_idx] <= miso;
                    if (bit_idx == 0) begin
                        rx_byte <= rx_shift;
                        running <= 1'b0;
                        busy <= 1'b0;
                        done <= 1'b1;
                        ss_n <= 1'b1;
                        sclk <= cpol;
                    end else begin
                        bit_idx <= bit_idx - 1;
                    end
                end
            end else begin
                // CPOL=1 -> negedge is leading
                if (cpha == 1'b0) begin
                    // CPHA=0: sample on leading
                    rx_shift[bit_idx] <= miso;
                    // decrement will occur on trailing (posedge) above
                end else begin
                    // CPHA=1: on leading shift out next MOSI
                    mosi <= tx_shift[bit_idx];
                end
            end
        end
    end

endmodule