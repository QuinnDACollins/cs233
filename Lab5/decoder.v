// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    // bne, beq, j, jr, lui, slt, lw, lbu, sw, sb, addm

    wire i_type = ((opcode == `OP_ANDI) | (opcode == `OP_ADDI)  | (opcode == `OP_ORI) | (opcode == `OP_XORI) | (opcode == `OP_BEQ) | 
                (opcode == `OP_BNE) | (opcode == `OP_LUI) | (opcode == `OP_LW) | (opcode == `OP_LBU) | (opcode == `OP_SW) | (opcode == `OP_SB));
    wire r_type = ((funct == `OP0_ADD) |(funct == `OP0_AND) | (funct == `OP0_SUB)  | (funct == `OP0_OR) | (funct == `OP0_NOR) | (funct == `OP0_XOR) |
                (funct == `OP0_JR) | (funct == `OP0_SLT) | (funct == `OP0_ADDM) ) & (opcode == `OP_OTHER0);
    wire j_type = (opcode == `OP_J);
    nor n1(except, i_type, r_type, j_type);

    // memory unit
    assign mem_read = (opcode == `OP_LW) | (opcode == `OP_LBU) | ((funct == `OP0_ADDM) & (opcode == `OP_OTHER0));
    assign word_we = (opcode == `OP_SW);
    assign byte_we = (opcode == `OP_SB);
    assign byte_load = (opcode == `OP_LBU) & ~((funct == `OP0_ADDM) & (opcode == `OP_OTHER0)); //uhhhh

    // random 
    assign lui = (opcode == `OP_LUI);
    assign slt = (funct == `OP0_SLT) & (opcode == `OP_OTHER0);
    assign addm = (funct == `OP0_ADDM) & (opcode == `OP_OTHER0);

    // This should still work
    assign rd_src = i_type & ~r_type;

    // control type
    assign control_type = ((opcode == `OP_BNE) & ~zero)| ((opcode == `OP_BEQ) & zero) ? 2'b01 : (opcode == `OP_J) ? 2'b10 : ((funct == `OP0_JR) & (opcode == `OP_OTHER0)) ? 2'b11 : 2'b00;


    assign writeenable = (i_type | r_type) & ~((opcode == `OP_BEQ) | (opcode == `OP_BNE) | (opcode == `OP_J) | (opcode == `OP_SW) | (opcode == `OP_SB) | ((funct == `OP0_JR) & (opcode == `OP_OTHER0)));


    // if addi or LW or LBU or SW or SB 01
    // else if r_type or BEQ or BNE 00
    // else 10
    assign alu_src2 = (opcode == `OP_ADDI) | (opcode == `OP_LW) | (opcode == `OP_LBU) | (opcode == `OP_SW) | (opcode == `OP_SB) ? 2'b01 :(opcode == `OP_BEQ) | 
                (opcode == `OP_BNE) |  r_type ? 2'b00 : 2'b10;


    assign alu_op = (((funct == `OP0_ADD) | (funct == `OP0_ADDM)) & (opcode == `OP_OTHER0)) | (opcode == `OP_ADDI) | (opcode == `OP_LW) | (opcode == `OP_LBU) | (opcode == `OP_SW) | (opcode == `OP_SB)? 3'b010 : // add
                    (((funct == `OP0_SUB) | (funct == `OP0_SLT)) & (opcode == `OP_OTHER0)) | (opcode == `OP_BEQ) | (opcode == `OP_BNE) ? 3'b011 : // subtract
                    ((funct == `OP0_AND) & (opcode == `OP_OTHER0)) | (opcode == `OP_ANDI) ? 3'b100 ://and
                    ((funct == `OP0_OR ) & (opcode == `OP_OTHER0)) | (opcode == `OP_ORI) ? 3'b101 :
                    ((funct == `OP0_NOR) & (opcode   == `OP_OTHER0)) ? 3'b110 :
                    ((funct == `OP0_XOR) & (opcode == `OP_OTHER0)) | (opcode == `OP_XORI) ? 3'b111 :
                    3'b000;
    //010

endmodule // mips_decode


//rd src
//alusrc2
