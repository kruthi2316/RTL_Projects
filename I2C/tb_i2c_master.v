// tb_i2c_master.v
// Testbench for the simple I2C Master module.

`timescale 1ns / 1ps

module tb_i2c_master;

    reg clk;
    reg rst_n;
    reg start;
    reg [6:0] slave_addr;
    reg [7:0] data_byte;

    wire busy;
    wire scl;
    wire sda_wire;

    reg slave_ack_active;

    // Model SDA line open-drain:
    // Slave pulls line low during ACK, else line is high impedance.
    assign sda_wire = (slave_ack_active) ? 1'b0 : 1'bZ;

    // Instantiate DUT
    i2c_master dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .slave_addr(slave_addr),
        .data_byte(data_byte),
        .busy(busy),
        .sda(sda_wire),
        .scl(scl)
    );

    // Slave ACK simulation logic
    integer slave_bit_count = 0;

    always @(negedge scl) begin
        if (!rst_n) begin
            slave_ack_active <= 1'b0;
            slave_bit_count <= 0;
        end else begin
            if (slave_bit_count == 8) begin
                slave_ack_active <= 1'b1; // ACK bit
            end else if (slave_bit_count == 9) begin
                slave_ack_active <= 1'b0; // Release SDA after ACK
                slave_bit_count <= 0;
            end else begin
                slave_bit_count <= slave_bit_count + 1;
            end
        end
    end

    // Reset slave counters on start/stop condition detection (optional robustness)
    wire is_start_cond = scl && dut.sda_reg && !sda_wire;
    wire is_stop_cond  = scl && !dut.sda_reg && sda_wire;

    always @(posedge is_start_cond or posedge is_stop_cond) begin
        slave_bit_count <= 0;
        slave_ack_active <= 1'b0;
    end

    // Clock generation: 50 MHz
    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        // VCD dump for GTKWave
        $dumpfile("i2c_wave.vcd");
        $dumpvars(0, tb_i2c_master);

        // Initialize signals
        rst_n = 0; start = 0; slave_addr = 0; data_byte = 0; slave_ack_active = 0;
        #20 rst_n = 1;

        // Start a write transaction
        slave_addr = 7'h2A;
        data_byte  = 8'hB3;
        #20;
        start = 1;
        #20;
        start = 0;

        // Wait until transaction ends
        wait (busy == 0);
        $display("Transaction finished at time %t", $time);

        #500;
        $finish;
    end

endmodule