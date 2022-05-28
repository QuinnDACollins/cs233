module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v
    reg A = 0;
    always #1 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg C = 0;
    always #4 C = !C;

    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        # 16 control = 3'b001; 
        # 16 control = 3'b010; 
        # 16 control = 3'b011; 
        # 16 control = 3'b100; 
        # 16 control = 3'b101; 
        # 16 control = 3'b110; 
        # 16 control = 3'b111; 
        # 16 $finish; 
    end

    wire c_out, out;
    alu1 al(out, c_out, A, B, C, control);
endmodule