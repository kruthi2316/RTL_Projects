`timescale 1ns/1ps

module watchdog_timer_tb;

    reg clk, rst, kick;
    wire wdt_reset;

    watchdog_timer uut (
        .clk(clk),
        .rst(rst),
        .kick(kick),
        .wdt_reset(wdt_reset)
    );

    initial begin
        $dumpfile("watchdog_timer.vcd");
        $dumpvars(0, watchdog_timer_tb);

        clk = 0; rst = 1; kick = 0;
        #10 rst = 0;

        // Kick periodically - no reset expected
        repeat (5) begin
            #8 kick = 1; #2 kick = 0;
        end

        // Stop kicking - expect reset
        #100;

        $finish;
    end

    always #5 clk = ~clk;

endmodule