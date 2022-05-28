// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;
    wire [31:0] PCplusfour;
    wire [31:0] A_data;
    wire [31:0] B_data;
    wire [31:0] B;
    wire [4:0] W_addr_mux_out;  
    wire [31:0] AB_alu_out;
    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11]; 
    wire [15:0] imm = inst[15:0];
    wire [5:0] op_wire = inst[31:26];
    wire [5:0] func_wire = inst[5:0];
    wire [29:0]inst_in = PC[31:2];
    wire [31:0]inst_mux = {{PCplusfour[31:28], inst[25:0]}, 2'b0};
    wire [31:0] SignExtImm = { {16{inst[15]}}, inst[15:0]};
    wire [31:0] ZeroExtImm = { 16'b0, inst[15:0]};
    wire [31:0] b_off = SignExtImm << 2;
    wire [31:0] slt_wire = {31'b0, negative};
    wire [2:0] alu_op;
    wire [31:0] lui_wire = {inst[15:0], 16'b0};
    wire overflow, zero, negative;

    wire W_en;
    wire rd_src;
    wire [1:0] alu_src2;
    wire except; 
    wire PC_en = 1;
    wire [31:0] the_four = 32'h4;
    wire mem_read;
    wire word_we;
    wire byte_we;
    wire byte_load;
    wire slt;
    wire lui;
    wire addm;
    wire[1:0] control_type;
    wire[31:0] byte_load_mux_out;
    wire[31:0] mem_read_mux_out;
    wire[31:0] slt_mux_out;
    wire[31:0] dm_out;
    wire[31:0] data4mux_out;
    wire[31:0] lui_mux_out;
    wire[31:0] nextPC;
    wire[31:0] branch;
    wire[31:0] addm_alu_out;
    wire[31:0] addm_mux_out;
    wire[31:0] lui_addm_mux_out;
    wire[31:0] data_mem_addr_in_mux_out;


    mips_decode md(alu_op[2:0], W_en, rd_src, alu_src2[1:0], except, control_type[1:0], mem_read, word_we, byte_we, byte_load, slt, lui, addm, op_wire, func_wire, zero);
    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);
    mux4v m4(nextPC, PCplusfour, branch, inst_mux, A_data, control_type[1:0]); 
    alu32 pcplus4(PCplusfour, , , , PC, the_four, `ALU_ADD);
    alu32 branch_offset(branch, , , , PCplusfour, b_off, `ALU_ADD);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, inst_in);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf(A_data, B_data, rs, rt, W_addr_mux_out, lui_addm_mux_out, W_en, clock, reset);

    /* add other modules */
    mux2v  m2(W_addr_mux_out, rd, rt, rd_src);
    mux3v m3(B, B_data, SignExtImm, ZeroExtImm, alu_src2); 
    alu32 alu1(AB_alu_out, overflow, zero, negative, A_data, B, alu_op);
    mux2v slt_mux(slt_mux_out, AB_alu_out, slt_wire, slt);
    mux2v mem_read_mux(mem_read_mux_out, slt_mux_out, byte_load_mux_out, mem_read);

    mux2v data_mem_addr_in_mux(data_mem_addr_in_mux_out, AB_alu_out, A_data, addm);
    data_mem dm(dm_out, data_mem_addr_in_mux_out, B_data, word_we, byte_we, clock, reset);
    mux4v  data_mem_4mux(data4mux_out, dm_out[7:0], dm_out[15:8], dm_out[23:16], dm_out[31:24], data_mem_addr_in_mux_out[1:0]);
    mux2v byte_load_mux(byte_load_mux_out, dm_out, data4mux_out, byte_load);
    mux2v lui_mux(lui_mux_out, mem_read_mux_out, lui_wire, lui);

    mux2v lui_addm_mux(lui_addm_mux_out, lui_mux_out, addm_alu_out, addm);
    alu32 addm_alu(addm_alu_out, , , , mem_read_mux_out, B_data, `ALU_ADD);
endmodule // full_machine
