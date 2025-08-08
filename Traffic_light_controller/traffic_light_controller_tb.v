`timescale 1ns/1ps

module traffic_light_controller_tb;

    reg clk, rst;
    wire [2:0] light;

    traffic_light_controller uut (
        .clk(clk),
        .rst(rst),
        .light(light)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic_light_controller.vcd");
        $dumpvars(0, traffic_light_controller_tb);

        clk = 0;
        rst = 1; #10;
        rst = 0;

        // Run simulation for 200 time units
        #300;
        $finish;
    end

endmodule