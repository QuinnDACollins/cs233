// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

    wire addW, addiW, subW, andW, andiW, orW, oriW, norW, xorW, xoriW;

    assign addW =  (opcode == `OP_OTHER0) & (funct == `OP0_ADD);
    assign addiW = (opcode == `OP_ADDI);

    assign subW =  ((opcode == `OP_OTHER0) & (funct == `OP0_SUB));

    assign andW = ((opcode == `OP_OTHER0) & (funct == `OP0_AND));
    assign andiW = (opcode == `OP_ANDI);

    assign orW =  (opcode == `OP_OTHER0) & (funct == `OP0_OR);
    assign oriW =  (opcode == `OP_ORI);

    assign norW = ((opcode == `OP_OTHER0) & (funct == `OP0_NOR));

    assign xorW = ((opcode == `OP_OTHER0) & (funct == `OP0_XOR));
    assign xoriW = (opcode == `OP_XORI);

    assign alu_op[0] = (subW | orW | xorW | oriW | xoriW);
    assign alu_op[1] = (addW | subW | norW | xorW | addiW | xoriW);
    assign alu_op[2] = (andW | orW | norW | xorW | andiW | oriW | xoriW);

    assign writeenable = (addW | addiW | subW | andW | andiW | orW | oriW | norW | xorW | xoriW);
    assign except = (~writeenable);

    assign rd_src = (addiW | andiW | oriW | xoriW);
    assign alu_src2[1] = (andiW | oriW | xoriW);
    assign alu_src2[0] = wIsAddi;

endmodule // mips_decode
