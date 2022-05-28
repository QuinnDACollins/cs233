module keypad(valid, number, a, b, c, d, e, f, g);

   //gates and ports declaration
   output     valid;
   output   [3:0] number;
   input     a, b, c, d, e, f, g;

   //wire declaration
   wire     w0, w1, w2, w3, w4, w5, w6, w7, w8, w9;

   //circuit (gb)+(da)+(db)+(dc)+(ea)+(eb)+(ec)+(fa)+(fb)+(fc) = keypad(valid, number, a,b,c,d,e,f,g)
   and zero_key(w0, g, b);                                    //valid = 1, number = 0
   and one_key(w1, d, a);                                     //valid = 1, number = 1
    and two_key(w2, d, b);                                     //valid = 1, number = 2
    and three_key(w3, d, c);                                   //valid = 1, number = 3
    and four_key(w4, e, a);                                    //valid = 1, number = 4
    and five_key(w5, e, b);                                    //valid = 1, number = 5
    and six_key(w6, e, c);                                     //valid = 1, number = 6
    and seven_key(w7, f, a);                                   //valid = 1, number = 7
    and eight_key(w8, f, b);                                   //valid = 1, number = 8
    and nine_key(w9, f, c);                                    //valid = 1, number = 9
    or o1(valid, w0, w1, w2, w3, w4, w5, w6, w7, w8, w9);      //check if the key is valid key

   //assigns bit value of the key number by translating the wire values into binary number
    assign number[3] = w8 | w9;
   assign number[2] = w4 | w5 | w6 | w7;
   assign number[1] = w2 | w3 | w6 | w7;
   assign number[0] = w1 | w3 | w5 | w7 | w9;

endmodule // keypad