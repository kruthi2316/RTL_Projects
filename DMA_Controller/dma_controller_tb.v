`timescale 1ns / 1ps

module dma_controller_tb;

parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 8;
parameter MEM_DEPTH  = 256;

reg clk;
reg rst_n;

reg ch0_start;
reg [ADDR_WIDTH-1:0] ch0_src;
reg [ADDR_WIDTH-1:0] ch0_dst;
reg [7:0] ch0_size;

reg ch1_start;
reg [ADDR_WIDTH-1:0] ch1_src;
reg [ADDR_WIDTH-1:0] ch1_dst;
reg [7:0] ch1_size;

wire mem_read_en;
wire mem_write_en;
wire [ADDR_WIDTH-1:0] mem_addr;
wire [DATA_WIDTH-1:0] mem_write_data;
reg  [DATA_WIDTH-1:0] mem_read_data;

wire ch0_done;
wire ch1_done;

// Instantiate DMA Controller
dma_controller dut (
    .clk(clk),
    .rst_n(rst_n),

    .ch0_start(ch0_start),
    .ch0_src(ch0_src),
    .ch0_dst(ch0_dst),
    .ch0_size(ch0_size),

    .ch1_start(ch1_start),
    .ch1_src(ch1_src),
    .ch1_dst(ch1_dst),
    .ch1_size(ch1_size),

    .mem_read_en(mem_read_en),
    .mem_write_en(mem_write_en),
    .mem_addr(mem_addr),
    .mem_write_data(mem_write_data),
    .mem_read_data(mem_read_data),

    .ch0_done(ch0_done),
    .ch1_done(ch1_done)
);

// Simple memory model
reg [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];

// Read data is direct from memory (asynchronous read)
always @(*) begin
    mem_read_data = memory[mem_addr];
end

// Write data to memory on write enable
always @(posedge clk) begin
    if (mem_write_en) begin
        memory[mem_addr] <= mem_write_data;
    end
end

integer i;

// Clock generator
initial clk = 0;
always #5 clk = ~clk;  // 100 MHz clock

initial begin
    $dumpfile("dma_controller_tb.vcd");
    $dumpvars(0, dma_controller_tb);

    rst_n = 0;
    ch0_start = 0; ch1_start = 0;
    ch0_src = 0; ch0_dst = 0; ch0_size = 0;
    ch1_src = 0; ch1_dst = 0; ch1_size = 0;

    for (i = 0; i < MEM_DEPTH; i = i + 1) begin
        memory[i] = i[DATA_WIDTH-1:0];
    end

    #20;
    rst_n = 1;
    #20;

    // Start channel 0 (transfer 2 bytes)
    ch0_src = 8'd10;
    ch0_dst = 8'd100;
    ch0_size = 8'd2;
    ch0_start = 1;
    @(posedge clk);
    ch0_start = 0;

    wait(ch0_done);
    $display("Channel 0 done at time %0t", $time);

    // Clear size after done to avoid re-trigger
    ch0_size = 0;

    $display("Memory[100..101] after channel 0:");
    for (i = 100; i < 102; i = i + 1)
        $display("Addr %0d = 0x%0h", i, memory[i]);

    // Start channel 1 (transfer 2 bytes)
    ch1_src = 8'd50;
    ch1_dst = 8'd150;
    ch1_size = 8'd2;
    ch1_start = 1;
    @(posedge clk);
    ch1_start = 0;

    wait(ch1_done);
    $display("Channel 1 done at time %0t", $time);

    ch1_size = 0;

    $display("Memory[150..151] after channel 1:");
    for (i = 150; i < 152; i = i + 1)
        $display("Addr %0d = 0x%0h", i, memory[i]);

    #50;
    $finish;
end

// Simulation timeout to avoid infinite running
initial begin
    #2000;
    $display("Simulation timeout reached - forcing finish.");
    $finish;
end

endmodule