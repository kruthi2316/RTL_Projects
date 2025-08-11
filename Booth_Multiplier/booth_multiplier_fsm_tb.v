// booth_multiplier_fsm_tb.v
`timescale 1ns / 1ps

module booth_multiplier_fsm_tb();

    reg clk;
    reg rst;
    reg start;
    reg signed [3:0] X, Y;
    wire signed [7:0] Z;
    wire valid;

    // Instantiate the DUT
    booth_multiplier_fsm uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .X(X),
        .Y(Y),
        .Z(Z),
        .valid(valid)
    );

    // Clock generation (period 10ns)
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("booth_multiplier_fsm.vcd");
        $dumpvars(0, booth_multiplier_fsm_tb);

        // Reset
        rst = 0; start = 0; X = 0; Y = 0;
        #15;
        rst = 1;
        #10;

        // Test 1: 3 * 4 = 12
        X = 4; Y = 3;
        start_pulse();
        wait(valid == 1);
        #10;
        $display("Test 1: %d * %d = %d (expected %d)", X, Y, Z, X*Y);

        // Test 2: -5 * 2 = -10
        X = -5; Y = 2;
        start_pulse();
        wait(valid == 1);
        #10;
        $display("Test 2: %d * %d = %d (expected %d)", X, Y, Z, X*Y);

        // Test 3: -3 * -3 = 9
        X = -3; Y = -3;
        start_pulse();
        wait(valid == 1);
        #10;
        $display("Test 3: %d * %d = %d (expected %d)", X, Y, Z, X*Y);

        // Test 4: 7 * -4 = -28
        X = 7; Y = -4;
        start_pulse();
        wait(valid == 1);
        #10;
        $display("Test 4: %d * %d = %d (expected %d)", X, Y, Z, X*Y);

        // Test 5: 0 * 0 = 0
        X = 0; Y = 0;
        start_pulse();
        wait(valid == 1);
        #10;
        $display("Test 5: %d * %d = %d (expected %d)", X, Y, Z, X*Y);

        $finish;
    end

    // Task to pulse start for one clock cycle
    task start_pulse;
    begin
        @(negedge clk);
        start = 1;
        @(negedge clk);
        start = 0;
    end
    endtask

endmodule