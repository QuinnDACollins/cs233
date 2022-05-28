//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);

             A = 8; B = 4; control = `ALU_ADD; // try adding 8 and 4
        # 10 A = 2; B = 5; control = `ALU_SUB; // try subtracting 5 from 2
        # 10 A = 5; B = 5; control = `ALU_SUB; // try subtracting 5 and 5 (zero test)
        # 10 A = 2147483648; B = 2147483648; control = `ALU_ADD; //try to get overflow thru adding
        # 10 A = -2147483645; B = 2147483645; control = `ALU_SUB; //try to get overflow thru subtracting

        // add more test cases here!

        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  
endmodule // alu32_test
