// spi_tb.v
// Testbench for spi_master + spi_slave
`timescale 1ns/1ps

module spi_tb;
    reg clk;
    reg rst;
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz system clock (10 ns period)

    parameter DATA_WIDTH = 8;

    // Master interface
    reg start;
    reg [DATA_WIDTH-1:0] master_tx;
    wire [DATA_WIDTH-1:0] master_rx;
    wire master_busy;
    wire master_done;
    wire sclk;
    wire mosi;
    wire ss_n;
    wire miso;

    reg cpol;
    reg cpha;
    reg [15:0] clk_div;

    // Slave interface
    reg [DATA_WIDTH-1:0] slave_tx;
    wire [DATA_WIDTH-1:0] slave_rx;

    // Instantiate master
    spi_master #(.DATA_WIDTH(DATA_WIDTH)) master_inst (
        .clk(clk),
        .rst(rst),
        .start(start),
        .tx_byte(master_tx),
        .miso(miso),
        .rx_byte(master_rx),
        .busy(master_busy),
        .done(master_done),
        .sclk(sclk),
        .mosi(mosi),
        .ss_n(ss_n),
        .cpol(cpol),
        .cpha(cpha),
        .clk_div(clk_div)
    );

    // Instantiate slave
    spi_slave #(.DATA_WIDTH(DATA_WIDTH)) slave_inst (
        .sclk(sclk),
        .ss_n(ss_n),
        .mosi(mosi),
        .miso(miso),
        .tx_byte(slave_tx),
        .rx_byte(slave_rx),
        .cpol(cpol),
        .cpha(cpha)
    );

    integer mode;

    initial begin
        $dumpfile("spi_tb.vcd");
        $dumpvars(0, spi_tb);

        // init
        rst = 1;
        start = 0;
        master_tx = 8'h00;
        slave_tx  = 8'h00;
        clk_div = 16'd10; // half period -> choose small to speed sim (10 sys clocks)
        #100;
        rst = 0;
        #100;

        for (mode = 0; mode < 4; mode = mode + 1) begin
            cpol = (mode >> 1) & 1;
            cpha = mode & 1;
            $display("\n\n=== Testing SPI mode %0d (CPOL=%b CPHA=%b) ===", mode, cpol, cpha);

            // test pattern 1
            master_tx = 8'hA5;
            slave_tx  = 8'h5A;
            #20;
            start_pulse();
            wait(master_done);
            #40;
            $display("Master sent 0x%02h, Master received 0x%02h, Slave received 0x%02h (slave_tx 0x%02h)",
                     master_tx, master_rx, slave_rx, slave_tx);

            // test pattern 2
            master_tx = 8'hFD;
            slave_tx  = 8'hB8;
            #20;
            start_pulse();
            wait(master_done);
            #40;
            $display("Master sent 0x%02h, Master received 0x%02h, Slave received 0x%02h (slave_tx 0x%02h)",
                     master_tx, master_rx, slave_rx, slave_tx);
        end

        $display("\nAll tests done.");
        #200;
        $finish;
    end

    // start pulse task
    task start_pulse;
        begin
            @(posedge clk);
            start = 1'b1;
            @(posedge clk);
            start = 1'b0;
        end
    endtask

endmodule