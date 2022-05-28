`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here

    wire   [31:0] status, cause, user_status;
    wire          exception_level;
    wire   [31:0] decoder_out, epc_extend;
    wire   [29:0] d_epc_register;
    wire          cause_status, status_out, sr_not;
    wire          exception_level_reset, epc_register_enable;

    assign status[31:16] = {16{1'b0}};
    assign status[15:8] = user_status[15:8];
    assign status[7:2] = {6{1'b0}};
    assign status[1] = exception_level;
    assign status[0] = user_status[0];

    assign cause[31:16] = {16{1'b0}};
    assign cause[15] = TimerInterrupt;
    assign cause[14:0] = {15{1'b0}};

    decoder32 decoderRegnum(decoder_out, regnum, MTC0);

    mux2v #(30) mux1(d_epc_register, wr_data[31:2], next_pc, TakenInterrupt);

    or orResetEL(exception_level_reset, reset, ERET);
    or orEnableEPC(epc_register_enable, decoder_out[14], TakenInterrupt);

    and causeStatus(cause_status, cause[15], status[15]);
    not notSR(sr_not, status[1]);
    and andStatus(status_out, sr_not, status[0]);
    and finalAnd(TakenInterrupt, cause_status, status_out);

    register #(32) userStatus(user_status, wr_data, clock, reset, decoder_out[12]);

    dffe exceptionLevel(exception_level, 1'b1, clock, exception_level_reset, TakenInterrupt);

    register #(30) epcRegister(EPC, d_epc_register, clock, reset, epc_register_enable);
    assign epc_extend[31:2] = EPC[29:0];
    assign epc_extend[1:0] = 2'b0;
    mux3v #(32) mux2(rd_data, status, cause, epc_extend, regnum[1:0]);

endmodule
