`timescale 1ns / 1ps

module uart_tb;

    reg clk;
    reg reset;

    // TX signals
    reg tx_start;
    reg [7:0] tx_data;
    wire tx_busy;
    wire tx_serial;

    // RX signals
    wire [7:0] rx_data;
    wire rx_ready;
    wire rx_error;
    reg rx_serial;

    localparam CLK_FREQ = 50000000;
    localparam BAUD_RATE = 115200;

    // Instantiate UART TX
    uart_tx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut_tx (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_busy(tx_busy),
        .tx_serial(tx_serial)
    );

    // Instantiate UART RX
    uart_rx #(
        .CLK_FREQ(CLK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) uut_rx (
        .clk(clk),
        .reset(reset),
        .rx_serial(rx_serial),
        .rx_data(rx_data),
        .rx_ready(rx_ready),
        .rx_error(rx_error)
    );

    // Connect TX output directly to RX input (loopback)
    always @(*) rx_serial = tx_serial;

    // Clock generation (50 MHz)
    initial clk = 0;
    always #10 clk = ~clk; // 20 ns period

    initial begin
        // Create VCD dump file
        $dumpfile("uart.vcd");
        $dumpvars(0, uart_tb);

        reset = 1;
        tx_start = 0;
        tx_data = 8'h00;
        #100;
        reset = 0;

        // Send 3 bytes
        send_byte(8'h55);   // U
        wait_rx_ready();

        send_byte(8'hA5);   // ¤
        wait_rx_ready();

        send_byte(8'hFF);   // 255
        wait_rx_ready();

        #1000;
        $finish;
    end

    // Task: send a byte via UART TX
    task send_byte(input [7:0] data);
    begin
        wait (!tx_busy);
        @(posedge clk);
        tx_data = data;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;
    end
    endtask

    // Task: wait until RX data is ready
    task wait_rx_ready;
    begin
        wait (rx_ready == 1);
        @(posedge clk);
        if (rx_error)
            $display("RX Error detected for data %h", rx_data);
        else
            $display("Received byte: %h", rx_data);
    end
    endtask

endmodule