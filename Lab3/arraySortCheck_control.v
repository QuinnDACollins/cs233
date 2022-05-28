// dffe: D-type flip-flop with enable
//
// q      (output) - Current value of flip flop
// d      (input)  - Next value of flip flop
// clk    (input)  - Clock (positive edge-sensitive)
// enable (input)  - Load new value? (yes = 1, no = 0)
// reset  (input)  - Asynchronous reset   (reset =  1)
//

module arraySortCheck_control(sorted, done, load_input, load_index, select_index, go, inversion_found, end_of_array, zero_length_array, clock, reset);
    output sorted, done, load_input, load_index, select_index;
    input go, inversion_found, end_of_array, zero_length_array;
    input clock, reset;

    //wire sGarbage, sTrue, sFalse, sNextIdx, sCompare, sPreStart, sEmptyArray, sEndOfArray, sFoundInversion, wCheck_next, sStart, TDone, FDone, incrementCheck_next;
    wire sGarbage, sStart, wCheck, sIncrement, sTDone, sFDone;
    // wire sGarbage_next = reset & (~go | sGarbage); 
    // wire sPreStart_next = go & sGarbage;
    wire sGarbage_next = (sGarbage & ~go | reset);
    wire sStart_next = ((sStart & go) | (sGarbage & go) | (sTDone & go) | (sFDone & go));

    wire wCheck_next = (sStart & ~go | sIncrement);
    wire sIncrement_next = (wCheck & ~end_of_array & ~zero_length_array & ~inversion_found);
    wire sTDone_next = (( end_of_array) | (zero_length_array) | (~go & sTDone));
    wire sFDone_next = ((inversion_found) | (~go & sFDone));


    dffe fsGarbage(sGarbage, sGarbage_next, clock, 1'b1, 1'b0);
    dffe fsPreStart(sStart, sStart_next, clock, 1'b1, 1'b0);

    dffe whileCheck(wCheck, wCheck_next, clock, 1'b1, 1'b0);
    dffe incrementCheck(sIncrement, sIncrement_next, clock, 1'b1, 1'b0);
    dffe trueDone(sTDone, sTDone_next, clock, 1'b1, 1'b0);
    dffe falseDone(sFDone, sFDone_next, clock, 1'b1, 1'b0);

	assign sorted = sTDone;
	assign done = sTDone | sFDone;
	assign select_index = sIncrement;
	assign load_input = wCheck;
	assign load_index = sIncrement;
endmodule