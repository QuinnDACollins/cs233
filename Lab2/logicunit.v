// 00 -> AND, 01 -> OR, 10 -> NOR, 11 -> XOR
module logicunit(out, A, B, control);
    output      out;
    input       A, B;
    input [1:0] control;
    wire wa, wo, wn, wx;

    and a1(wa, A, B);
    or o1(wo, A, B);
    nor n1(wn, A, B);
    xor x1(wx, A, B);

    mux4 m(out, wa, wo, wn, wx, control);
endmodule // logicunit
