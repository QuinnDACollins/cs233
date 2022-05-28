module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    wire   [31:0] cycounter_out, intercy_out, cycle_alu_out;
    assign interline_enable = intercy_out == cycounter_out;
    assign interline_reset = (Acknowledge | reset);
    assign addr_eq1 = (32'hffff001c == address);
    assign addr_eq2 = (32'hffff006c == address);
    assign Acknowledge = (MemWrite & addr_eq2);
    assign TimerRead = (MemRead & addr_eq1);
    assign TimerWrite = (MemWrite & addr_eq1);
    assign TimerAddress = (addr_eq1 | addr_eq2);
    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle
    register cycounter(cycounter_out, cycle_alu_out, clock, 1'b1, reset);
    alu32    cycle_alu(cycle_alu_out, , , `ALU_ADD, cycounter_out, 1'b1);

    register  #(32, 32'hffffffff) intercy(intercy_out, data, clock, TimerWrite, reset);

    register #(1, 32'hffffffff) interline(TimerInterrupt, 1'b1, clock, interline_enable, interline_reset);

    tristate cycle_tri(cycle, cycounter_out, TimerRead);
endmodule
