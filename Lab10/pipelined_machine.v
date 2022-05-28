module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4, PC_target;
    wire [31:0]  inst;

    //original PC wires
    wire [31:0]  imm = {{ 16{inst[15]} }, inst[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst[25:21];
    wire [4:0]   rt = inst[20:16];
    wire [4:0]   rd = inst[15:11];
    wire [5:0]   opcode = inst[31:26];
    wire [5:0]   funct = inst[5:0];


    //reg wires
    wire [4:0]   wr_regnum;
    wire [2:0]   ALUOp;
    wire         RegWrite, BEQ, ALUSrc, MemRead, MemWrite, MemToReg, RegDst;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data, B_data, alu_out_data, load_data, wr_data;


    //Forwarding stuff
    wire [31:2]  nPC_plus4;
    wire [31:0]  old_inst, forwardBOutput, old_alu_out_data, forwardAOutput, old_forwardBOutput;
    wire         forwardA, forwardB, stall, oldRW, oldMR, oldMW, oldMTR;
    wire [4:0]   old_wr_regnum;


    //so that we can stall our circuit
    assign stall = (MemRead && (((rs == wr_regnum) && (rs != 0)) || ((rt == wr_regnum) && (rt != old_wr_regnum) && (rt != 0))));

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, ~stall, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4, PC[31:2], 30'h1);

    register #(30) nPC_plus4Reg(nPC_plus4, PC_plus4, clk, ~stall, (PCSrc | reset));
    adder30 target_PC_adder(PC_target, nPC_plus4, imm[29:0]);

    mux2v #(30) branch_mux(next_PC, PC_plus4, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(old_inst, PC[31:2]);
    register #(32) instReg(inst, old_inst, clk, ~stall, (PCSrc | reset));

    mips_decode decode(ALUOp, oldRW, BEQ, ALUSrc, oldMR, oldMW, oldMTR, RegDst, opcode, funct);
    register #(1) Reg2Reg(RegWrite, oldRW, clk, 1'b1, reset);
    register #(1) MemFromReg(MemRead, oldMR, clk, 1'b1, reset);
    register #(1) Mem2Reg(MemWrite, oldMW, clk, 1'b1, reset);
    register #(1) Reg4Mem2Reg(MemToReg, oldMTR, clk, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data,
               rs, rt, wr_regnum, wr_data,
               RegWrite, clk, reset);
    register #(32) forwardBOutputReg(forwardBOutput, old_forwardBOutput, clk, /* enable */1'b1, reset);

    mux2v #(32) imm_mux(B_data, old_forwardBOutput, imm, ALUSrc);
    
    alu32 alu(old_alu_out_data, zero, ALUOp, forwardAOutput, B_data);
    register #(32) alu_out_dataReg(alu_out_data, old_alu_out_data, clk, /* enable */1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data, forwardBOutput, MemRead, MemWrite, clk, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data, load_data, MemToReg);

    mux2v #(5) rd_mux(old_wr_regnum, rt, rd, RegDst);
    register #(5) wr_regnumReg(wr_regnum, old_wr_regnum, clk, /* enable */1'b1, reset);

    assign forwardA = (RegWrite && (rs == wr_regnum) && (rs != 0));
    assign forwardB = (RegWrite && (rt == wr_regnum) && (rt != 0));
    mux2v #(32) fAMux(forwardAOutput, rd1_data, alu_out_data, forwardA);
    mux2v #(32) fBMux(old_forwardBOutput, rd2_data, alu_out_data, forwardB);

endmodule // pipelined_machine