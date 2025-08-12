// memory_controller_tb.v
// Clean variable names and formatting

`timescale 1ns / 1ps

module memory_controller_tb;

    // Parameters
    localparam DATA_WIDTH    = 8;
    localparam ADDR_WIDTH    = 16;
    localparam MEM_BASE_ADDR = 16'h1000;
    localparam MEM_ADDR_BITS = 11;
    localparam MEM_DEPTH     = 1 << MEM_ADDR_BITS;

    // Testbench signals
    reg                     clk;
    reg                     reset_n;
    integer                 i, fail_count = 0;
    reg  [ADDR_WIDTH-1:0]   rand_addr;
    reg  [DATA_WIDTH-1:0]   rand_data;

    // CPU side
    reg  [ADDR_WIDTH-1:0]   cpu_addr;
    reg  [DATA_WIDTH-1:0]   cpu_write_data;
    reg                     cpu_read_en;
    reg                     cpu_write_en;
    wire [DATA_WIDTH-1:0]   cpu_read_data;
    wire                    cpu_ready;

    // Memory side
    wire [DATA_WIDTH-1:0]   mem_read_data;
    wire [MEM_ADDR_BITS-1:0] mem_addr;
    wire [DATA_WIDTH-1:0]   mem_write_data;
    wire                    mem_write_en;
    wire                    mem_chip_en;

    // DUT
    memory_controller #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .MEM_BASE_ADDR(MEM_BASE_ADDR),
        .MEM_ADDR_BITS(MEM_ADDR_BITS)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .cpu_addr(cpu_addr),
        .cpu_write_data(cpu_write_data),
        .cpu_read_en(cpu_read_en),
        .cpu_write_en(cpu_write_en),
        .cpu_read_data(cpu_read_data),
        .cpu_ready(cpu_ready),
        .mem_read_data(mem_read_data),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .mem_chip_en(mem_chip_en)
    );

    // Simple synchronous RAM model
    reg [DATA_WIDTH-1:0] ram[0:MEM_DEPTH-1];
    always @(posedge clk) begin
        if (mem_chip_en && mem_write_en) begin
            ram[mem_addr] <= mem_write_data;
        end
    end
    assign mem_read_data = ram[mem_addr];

    // Clock generator
    always #5 clk = ~clk;

    // Write task
    task write_mem(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
    begin
        @(posedge clk);
        cpu_addr       <= addr;
        cpu_write_data <= data;
        cpu_write_en   <= 1'b1;
        @(posedge clk);
        cpu_write_en   <= 1'b0;
        while (!cpu_ready) @(posedge clk);
        $display("[%t] WRITE: 0x%h -> 0x%h", $time, data, addr);
    end
    endtask

    // Read task
    task read_mem(input [ADDR_WIDTH-1:0] addr);
    begin
        @(posedge clk);
        cpu_addr     <= addr;
        cpu_read_en  <= 1'b1;
        @(posedge clk);
        cpu_read_en  <= 1'b0;
        while (!cpu_ready) @(posedge clk);
        $display("[%t] READ: 0x%h", $time, addr);
    end
    endtask

    // Main sequence
    initial begin
        $dumpfile("memory_controller.vcd");
        $dumpvars(0, memory_controller_tb);

        clk = 0;
        reset_n = 0;
        cpu_addr = 0;
        cpu_write_data = 0;
        cpu_read_en = 0;
        cpu_write_en = 0;

        #20 reset_n = 1;
        #20;

        for (i = 0; i < 8; i = i + 1) begin
            rand_addr = MEM_BASE_ADDR + {$random} % MEM_DEPTH;
            rand_data = {$random};

            write_mem(rand_addr, rand_data);
            read_mem(rand_addr);
            @(posedge clk);

            if (cpu_read_data == rand_data) begin
                $display("--> PASS: Data match 0x%h", cpu_read_data);
            end else begin
                $display("--> FAIL: Expected 0x%h, got 0x%h", rand_data, cpu_read_data);
                fail_count = fail_count + 1;
            end
            #50;
        end

        $display("\nFINAL SUMMARY:");
        if (fail_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TESTS FAILED", fail_count);

        $finish;
    end

endmodule