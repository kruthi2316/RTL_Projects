`timescale 1ns/1ps

module traffic_light_pedestrian_tb;

    reg clk, rst, pedestrian_request;
    wire [2:0] light;
    wire walk;

    traffic_light_pedestrian uut (
        .clk(clk),
        .rst(rst),
        .pedestrian_request(pedestrian_request),
        .light(light),
        .walk(walk)
    );

    initial begin
        $dumpfile("traffic_light_pedestrian.vcd");
        $dumpvars(0, traffic_light_pedestrian_tb);

        clk = 0;
        rst = 1;
        pedestrian_request = 0;
        #10 rst = 0;

        // Normal cycle, then pedestrian presses button at time 60ns
        #30 pedestrian_request = 1;
        #30 pedestrian_request = 0;

        #200 $finish;
    end

    always #5 clk = ~clk;

endmodule