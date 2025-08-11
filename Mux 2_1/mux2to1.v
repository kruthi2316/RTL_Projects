// 2:1 Multiplexer 
module mux2to1 (
    input a, b, sel,
    output y
);
    assign y = sel ? b : a;
endmodule