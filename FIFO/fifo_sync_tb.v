// Testbench for Synchronous FIFO
`timescale 1ns/1ps

module fifo_sync_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 4;

    reg clk, rst;
    reg wr_en, rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full, empty;

    fifo_sync #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    initial begin
        $dumpfile("fifo_sync.vcd");
        $dumpvars(0, fifo_sync_tb);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        #10 rst = 0;

        // Write 4 values
        repeat (4) begin
            @(posedge clk);
            wr_en = 1;
            din = din + 1;
        end

        @(posedge clk);
        wr_en = 0;

        // Read 4 values
        repeat (4) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;

        #20 $finish;
    end

    always #5 clk = ~clk;

endmodule