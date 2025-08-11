`timescale 1ns/1ps

module register_file_tb;

    reg clk;
    reg rst;
    reg en;
    reg [2:0] waddr;
    reg [7:0] wdata;
    reg [2:0] raddr1, raddr2;
    wire [7:0] rdata1, rdata2;

    // Instantiate the module
    register_file uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .waddr(waddr),
        .wdata(wdata),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("register_file.vcd");
        $dumpvars(0, register_file_tb);

        // Init
        clk = 0;
        rst = 1;
        en = 0;
        waddr = 0;
        wdata = 0;
        raddr1 = 0;
        raddr2 = 0;

        #10 rst = 0;

        // Write data into registers
        en = 1;
        waddr = 3; wdata = 8'hAA; #10;
        waddr = 5; wdata = 8'h55; #10;
        waddr = 7; wdata = 8'hFF; #10;

        en = 0; // disable write

        // Read from registers
        raddr1 = 3; raddr2 = 5; #10;
        raddr1 = 7; raddr2 = 2; #10;

        $finish;
    end

endmodule