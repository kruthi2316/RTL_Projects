// Basic Register File: 8x8 (8 registers, each 8 bits wide)
module register_file (
    input wire clk,
    input wire rst,
    input wire en,                  // Write Enable
    input wire [2:0] waddr,         // Write Address (3 bits for 8 registers)
    input wire [7:0] wdata,         // Write Data
    input wire [2:0] raddr1,        // Read Address 1
    input wire [2:0] raddr2,        // Read Address 2
    output wire [7:0] rdata1,       // Read Data 1
    output wire [7:0] rdata2        // Read Data 2
);

    // 8 registers of 8 bits
    reg [7:0] reg_array[7:0];
    integer i;
    // Synchronous write
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to 0
            for (i = 0; i < 8; i = i + 1)
                reg_array[i] <= 8'b0;
        end else if (en) begin
            reg_array[waddr] <= wdata;
        end
    end

    // Asynchronous read
    assign rdata1 = reg_array[raddr1];
    assign rdata2 = reg_array[raddr2];

endmodule