// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire [31:0] A_data;
    wire [31:0] B_data;
    wire [4:0] W_addr_mux_out;  
    wire [31:0] W_data;
    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11]; 
    wire [5:0] op_wire = inst[31:26];
    wire [5:0] func_wire = inst[5:0];
    wire [29:0]inst_in = PC[31:2];
    wire [31:0] SignExtImm = { {16{inst[15]}}, inst[15:0] };
    wire [31:0] ZeroExtImm = { 16'b0, inst[15:0]};
    wire [2:0] alu_op;
    wire overflow, zero, negative;
    wire [31:0] B_imm_mux3;
    wire W_en;
    wire rd_src;
    wire [1:0] alu_src2;
    wire except; 
    wire PC_en = 1;
    wire [31:0] the_four = 32'h4;

    mips_decode md(rd_src, W_en, alu_src2, alu_op, except, op_wire, func_wire);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1, reset);
    alu32 pcplus4(nextPC, , , , PC, the_four, `ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, inst_in);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf(A_data, B_data, rs, rt, W_addr_mux_out, W_data, W_en, clock, reset);

    /* add other modules */
    
    mux2v  m2(W_addr_mux_out, rd, rt, rd_src);
    mux3v m3(B_imm_mux3, B_data, SignExtImm, ZeroExtImm, alu_src2); 
    alu32 alu1(W_data, overflow, zero, negative, A_data, B_imm_mux3, alu_op);
endmodule // arith_machine
