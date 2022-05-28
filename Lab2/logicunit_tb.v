module logicunit_test;
    // these are inputs to "logicunit under test"
    reg A = 0;
    always #2 A = !A;
    reg B = 0;
    always #1 B = !B;

    reg [1:0] control;
    
    // wires for the outputs of "logicunit under test"
    wire out;
    
    // the circuit under test
    logicunit l(out, A, B, control);  
    
    initial begin               // initial = run at beginning of simulation
                                // begin/end = associate block with initial

        $dumpfile("logicunit.vcd");
        $dumpvars(0, logicunit_test);

        // test all input combinations
        control = 0; #4
        control = 1; #4
        control = 2; #4
        control = 3; #3
        $finish; // end the simulation
    end                  
   
    initial begin
        $display("A   B   Control    Out");
        $monitor("A=%b B=%b Control=%b Out=%b", A, B, control, out);
    end

endmodule // logicunit_test
