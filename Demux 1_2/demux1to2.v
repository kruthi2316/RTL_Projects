// 1:2 Demultiplexer 
module demux1to2 (
    input wire in,
    input wire sel,
    output wire y0,
    output wire y1
);
    assign y0 = (sel == 1'b0) ? in : 1'b0;
    assign y1 = (sel == 1'b1) ? in : 1'b0;
endmodule