//implement your 32-bit ALU
module alu32(out, overflow, zero, negative, A, B, control);
    output [31:0] out;
    output        overflow, zero, negative;
    input  [31:0] A, B;
    input   [2:0] control;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32;

    alu1 a0(out[0], w1, A[0], B[0], control[0], control);
    alu1 a1(out[1],w2,A[1],B[1], w1,control);
    alu1 a2(out[2],w3,A[2],B[2], w2,control);
    alu1 a3(out[3],w4,A[3],B[3], w3,control);
    alu1 a4(out[4],w5,A[4],B[4], w4,control);
    alu1 a5(out[5],w6,A[5],B[5], w5,control);
    alu1 a6(out[6],w7,A[6],B[6], w6,control);
    alu1 a7(out[7],w8,A[7],B[7], w7,control);
    alu1 a8(out[8],w9,A[8],B[8], w8,control);
    alu1 a9(out[9],w10,A[9],B[9], w9,control);
    alu1 a10(out[10],w11,A[10],B[10], w10,control);
    alu1 a11(out[11],w12,A[11],B[11], w11,control);
    alu1 a12(out[12],w13,A[12],B[12], w12,control);
    alu1 a13(out[13],w14,A[13],B[13], w13,control);
    alu1 a14(out[14],w15,A[14],B[14], w14,control);
    alu1 a15(out[15],w16,A[15],B[15], w15,control);
    alu1 a16(out[16],w17,A[16],B[16], w16,control);
    alu1 a17(out[17],w18,A[17],B[17], w17,control);
    alu1 a18(out[18],w19,A[18],B[18], w18,control);
    alu1 a19(out[19],w20,A[19],B[19], w19,control);
    alu1 a20(out[20],w21,A[20],B[20], w20,control);
    alu1 a21(out[21],w22,A[21],B[21], w21,control);
    alu1 a22(out[22],w23,A[22],B[22], w22,control);
    alu1 a23(out[23],w24,A[23],B[23], w23,control);
    alu1 a24(out[24],w25,A[24],B[24], w24,control);
    alu1 a25(out[25],w26,A[25],B[25], w25,control);
    alu1 a26(out[26],w27,A[26],B[26], w26,control);
    alu1 a27(out[27],w28,A[27],B[27], w27,control);
    alu1 a28(out[28],w29,A[28],B[28], w28,control);
    alu1 a29(out[29],w30,A[29],B[29], w29,control);
    alu1 a30(out[30],w31,A[30],B[30], w30,control);
    alu1 a31(out[31],w32,A[31],B[31], w31,control);
    
    nor nor1(zero, out[0], out[1], out[2], out[3], out[4], out[5], out[6], out[7], out[8], out[9], out[10], out[11], out[12], out[13], out[14], out[15], out[16], out[17], out[18], out[19], out[20], out[21], out[22], out[23], out[24], out[25], out[26], out[27], out[28], out[29], out[30], out[31]);
    xor xor1(overflow, w32, w31);
    assign negative = (out[31]);
endmodule // alu32
