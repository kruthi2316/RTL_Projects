// and_gate.v
module and_gate (
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule