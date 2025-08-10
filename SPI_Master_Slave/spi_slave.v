// spi_slave.v
// Verilog-2001
// Edge-accurate SPI slave that matches master's leading/trailing semantics.
// Parameterizable DATA_WIDTH, CPOL/CPHA support.

`timescale 1ns/1ps
module spi_slave #(
    parameter DATA_WIDTH = 8
)(
    input  wire                   sclk,
    input  wire                   ss_n,      // active low
    input  wire                   mosi,
    output reg                    miso,
    input  wire [DATA_WIDTH-1:0]  tx_byte,   // preload transmit data before SS low
    output reg [DATA_WIDTH-1:0]   rx_byte,
    input  wire                   cpol,
    input  wire                   cpha
);
    reg [DATA_WIDTH-1:0] tx_shift;
    reg [DATA_WIDTH-1:0] rx_shift;
    integer bit_idx;
    reg active;

    // Load tx_shift and reset indices on SS falling edge (transaction start)
    always @(negedge ss_n) begin
        tx_shift <= tx_byte;
        rx_shift <= {DATA_WIDTH{1'b0}};
        bit_idx  <= DATA_WIDTH - 1;
        active   <= 1'b1;
        // For CPHA==0, miso must be valid before first leading edge
        if (cpha == 1'b0) begin
            miso <= tx_byte[DATA_WIDTH-1];
        end else begin
            miso <= 1'b0; // will be set on first leading edge
        end
    end

    // Deactivate on SS rising (end of transaction) and present received byte
    always @(posedge ss_n) begin
        active <= 1'b0;
        rx_byte <= rx_shift;
        // keep miso stable or drive idle low
        miso <= 1'b0;
    end

    // posedge sclk handling
    always @(posedge sclk) begin
        if (active) begin
            if (cpol == 1'b0) begin
                // posedge is leading
                if (cpha == 1'b0) begin
                    // CPHA=0: sample on leading
                    rx_shift[bit_idx] <= mosi;
                    // bit_idx decrement done on trailing
                end else begin
                    // CPHA=1: on leading drive miso (current bit)
                    miso <= tx_shift[bit_idx];
                end
            end else begin
                // CPOL=1 -> posedge is trailing
                if (cpha == 1'b0) begin
                    // CPHA=0: trailing -> prepare next miso and decrement
                    if (bit_idx == 0) begin
                        // finished shifting; nothing to do (last sample was on previous leading)
                        // keep miso stable low
                        miso <= 1'b0;
                    end else begin
                        bit_idx <= bit_idx - 1;
                        miso <= tx_shift[bit_idx-1];
                    end
                end else begin
                    // CPHA=1: trailing -> sample
                    rx_shift[bit_idx] <= mosi;
                    if (bit_idx == 0) begin
                        // last sample done
                    end else begin
                        bit_idx <= bit_idx - 1;
                    end
                end
            end
        end
    end

    // negedge sclk handling
    always @(negedge sclk) begin
        if (active) begin
            if (cpol == 1'b0) begin
                // posedge is leading -> negedge is trailing
                if (cpha == 1'b0) begin
                    // CPHA=0: trailing -> prepare next miso and decrement
                    if (bit_idx == 0) begin
                        miso <= 1'b0;
                    end else begin
                        bit_idx <= bit_idx - 1;
                        miso <= tx_shift[bit_idx-1];
                    end
                end else begin
                    // CPHA=1: trailing -> sample
                    rx_shift[bit_idx] <= mosi;
                    if (bit_idx == 0) begin
                        // last sample done
                    end else begin
                        bit_idx <= bit_idx - 1;
                    end
                end
            end else begin
                // CPOL=1 -> negedge is leading
                if (cpha == 1'b0) begin
                    // CPHA=0: sample on leading
                    rx_shift[bit_idx] <= mosi;
                end else begin
                    // CPHA=1: on leading drive miso
                    miso <= tx_shift[bit_idx];
                end
            end
        end
    end

endmodule