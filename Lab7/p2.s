# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:
        bge $a1, $a0, true_val #  dots1 < dots2

        false_val:
        mul $t0, $a1, $a2
        add $t0  $t0  $a0
        add $t0  $t0  1
        move $v0 $t0
        jr $ra
        true_val:
        mul $t0, $a0, $a2
        add $t0  $t0  $a1
        add $t0  $t0  1
        move $v0 $t0
        jr $ra

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).
        # int solve(dominosa_question* puzzle, 
        #           unsigned char* solution,
        #           int row,
        #           int col) {
        #
        #     int num_rows = puzzle->num_rows;
        #     int num_cols = puzzle->num_cols;
        #     int max_dots = puzzle->max_dots;
        sub     $sp     $sp     32
        sw      $s0     0($sp)  #       RA REG
        sw      $s1     4($sp)  #       PUZZLE*
        sw      $s2     8($sp)  #       SOLUTION*
        sw      $s3     12($sp)  #      int rows
        sw      $s4     16($sp)  #      int columns
        sw      $s5     20($sp)  #      schmovement register
        sw      $s6     24($sp)  #      how many of these am i allowed to have again
        sw      $s7     28($sp)  #      wait im OUT

        move    $s0     $ra

        move    $s1     $a0     #       PUZZLE *
        move    $s2     $a1     #       SOLUTION *
        move    $s3     $a2     #       rows
        move    $s4     $a3     #       cols

        
        lw      $t6     4($s1)  #       num_rows = puzzle->num_cols;

        move    $a0     $s3     #       PREP FOR NEXT_ROW
        move    $a1     $s4
        move    $a2     $t6
        jal     next_row        #       ((col == num_cols - 1) ? row + 1 : row);
        
        move    $s5     $v0     #       NEXT_ROW IN $s5

        
        lw      $t6     4($s1)  #       num_rows = puzzle->num_cols;

        move    $a0     $s4     #       PREP FOR NEXT_COL
        move    $a1     $t6
        jal     next_col        #       (col + 1) % num_cols;
 
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;
        move    $t4     $s5     #       next_row        
        move    $t3     $v0     #       next_col
        lw      $t2     12($s1) #       unsigned char* dominos_used = puzzle->dominos_used;
        
        #       BASE CASE #1 START      (row >= num_rows || col >= num_cols) 
        base_1_orif:
        #       could be wrong, fix to standard if it is
        bge     $s3     $t7     base_1_end
        bge     $s4     $t6     base_1_end
        j       recurse_1_if
        base_1_end:
        move    $ra     $s0
        
        lw      $s0     0($sp)  #       RA REG
        lw      $s1     4($sp)  #       PUZZLE*
        lw      $s2     8($sp)  #       SOLUTION*
        lw      $s3     12($sp)  #      int rows
        lw      $s4     16($sp)  #      int columns
        lw      $s5     20($sp)  #      schmovement register
        lw      $s6     24($sp)  #      how many of these am i allowed to have again
        lw      $s7     28($sp)  #      wait im OUT
        add     $sp     $sp     32
        add     $v0     $zero	1
        jr      $ra          

        #       RECURSE #1 #START       (solution[row * num_cols + col] != 0)
        recurse_1_if:
         
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;

        mul     $t1     $s3     $t6     # PREPPING SOLUTION INDEX
        add     $t1     $t1     $s4     # PREPPING SOLUTION INDEX
        add     $t1     $s2     $t1     # ADD TO THE SOLUTION POINTERR!!!!
        lb     $t1     0($t1)
        beq     $t1     0       logic

        move    $a0     $s1             # return solve(puzzle, solution, next_row, next_col)
        move    $a1     $s2
        move    $a2     $t4
        move    $a3     $t5
        jal     solve  

        move $ra $s0
        lw $s0, 0($sp)
        lw $s1, 4($sp)
        lw $s2, 8($sp)
        lw $s3, 12($sp)
        lw $s4, 16($sp)
        lw $s5, 20($sp)
        lw $s6, 24($sp)
        lw $s7, 28($sp)
        add $sp $sp 32
        jr $ra

        logic:
        #       may be error prone.
         
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;


        mul     $t1     $s3     $t6     # PREP BOARD INDEX  
        add     $t1     $t1     $s4     # PREP BOARD INDEX  
        lb      $t0     12($s1)         # grab BOARD POINTER!!!
        add     $s6     $t0     $t1     # ADD INDEX TO INIT POINTER
        lb     $s6     0($s6)          # LOAD THAT INTO $s6 $S6 = CURR_DOTS
        #       t1, t0, t8, t9 free
        if_log1_cond1:
        sub     $t0     $t7     1       # num_rows - 1 
        bge     $s3     $t0     if_log1_cond2
        j if_log2_cond1
        if_log1_cond2:
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        add     $t0     $s3     1       # row + 1
        mul     $t0     $t0     $t6     # (row + 1) * num_cols
        add     $t0     $t0     $s4     # +cols
        add     $t0     $t0     $s2   # ADD INDEX TO INIT SOLUTION POINTER
        lbu     $t0     0($t0)        # grab BOARD POINTER!!!
        bne     $t0     0       if_log1_log        # == 0
        j       if_log2_cond1
        if_log1_log:
        move    $a2     $t5           # max_dots
        lb     $t8     12($s1)       # grab BOARD POINTER!!!
        add     $t8     $t8     $t2
        lbu     $a1     0($t2)        # puzzle->board[(row + 1) * num_cols + col]
        move    $a0     $s6           # (curr_dots)

        jal     encode_domino

        move    $s7     $t3     #       #S7 is now NEXT_COL, $S5 IS STILL NEXT_ROW
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;
        lb      $t4     16($s1) #       unsigned char* dominos_used = puzzle->dominos_used;
        move    $t3     $v0     #       t3 now has domino code

        if_inner_log1_log:
        add     $t2     $t4     $t3     #       prep (dominos_used[domino_code]
        lbu     $t1     0($t2)          #       (dominos_used[domino_code]
        bne     $t1     0       if_inner_inner_log1_log #       (dominos_used[domino_code] == 0) {
        j       if_log2_cond1

        if_inner_inner_log1_log:
        li      $t1     1
        sb      $t1     0($t2)          #       dominos_used[domino_code] = 1;
        mul     $t1     $s3     $t6
        add     $t1     $t1     $s4
        add     $t9     $t1     $s2     #       solution[row * num_cols + col]  
        sb      $t3     0($t9)          #       solution[(row * num_cols + col] = domino_code;

        add     $t1     $s3     1
        mul     $t1     $t1     $t6
        add     $t1     $t1     $s4
        add     $t9     $t1     $s2     #       solution[(row + 1) * num_cols + col]  
        sb      $t3     0($t9)          #       solution[(row + 1) * num_cols + col] = domino_code;

        move    $a0     $s1             # return solve(puzzle, solution, next_row, next_col)
        move    $a1     $s2
        move    $a2     $s5
        move    $a3     $s7
        move    $s6     $t3
        jal solve
        bne     $v0     1       base_1_end
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;
        lb      $t4     16($s1) #       unsigned char* dominos_used = puzzle->dominos_used;
        move    $t3     $s6     #       t3 now has domino code
        add     $t2     $t2     $t4     # t2 has dominos_used[domino_code]
        sb      $zero   0($t2)
        mul     $t0     $s3     $t6
        add     $t0     $t0     $s4  
        add     $t0     $s2     $t0
        sb      $zero   0($t0)    
        add     $t0     $s3     1
        mul     $t0     $t0     $t6
        add     $t0     $t0     $s4  
        add     $t0     $s2     $t0
        sb      $zero   0($t0)

        if_log2_cond1:
        sub     $t0     $t6     1       # num_rows - 1 
        ble     $s3     $t0     if_log2_cond2
        j return_end

        if_log2_cond2:
        add     $t0     $s4     1       # col + 1
        mul     $t1     $s3     $t6     # (row * num_cols
        add     $t0     $t1     $t0     # +cols + 1
        add     $t8     $t0     $s2   # ADD INDEX TO INIT SOL POINTER
        lbu     $t0     0($t8)        # grab SOL POINTER!!!
        beq     $t0     0       if_log2_log        # == 0
        j       return_end

        if_log2_log:
        move    $a2     $t5           # max_dots
        lb      $t8     12($s1)       # grab BOARD POINTER!!!
        add     $t8     $t8     $t0
        lbu      $a1     0($t0)       # puzzle->board[(row * num_cols + col + 1]
        move    $a0     $s6           # (curr_dots)

        jal     encode_domino

        move    $s7     $t3     #       #S7 is now NEXT_COL, $S5 IS STILL NEXT_ROW
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;
        lb      $t4     16($s1) #       unsigned char* dominos_used = puzzle->dominos_used;
        move    $t3     $v0     #       t3 now has domino code

        if_inner_log2_log:
        add     $t2     $t4     $t3     #       prep (dominos_used[domino_code]
        lbu     $t1     0($t2)          #       (dominos_used[domino_code]
        bne     $t1     0       if_inner_inner_log2_log #       (dominos_used[domino_code] == 0) {
        j       return_end

        if_inner_inner_log2_log:
        li      $t1     1
        sb      $t1     0($t2)          #       dominos_used[domino_code] = 1;
        mul     $t1     $s3     $t6
        add     $t1     $t1     $s4
        add     $t9     $t1     $s2     #       solution[row * num_cols + col]  
        sb      $t3     0($t9)          #       solution[(row * num_cols + col] = domino_code;

        add     $t1     $s4     1
        mul     $t2     $s3     $t6
        add     $t1     $t2     $t1
        add     $t9     $t1     $s2     #       solution[(row * num_cols + col]  
        sb      $t3     0($t9)          #       solution[(row + 1) * num_cols + col] = domino_code;

        move    $a0     $s1             # return solve(puzzle, solution, next_row, next_col)
        move    $a1     $s2
        move    $a2     $s5
        move    $a3     $s7
        move    $s6     $t3
        jal solve
        bne     $v0     1       base_1_end
        lw      $t7     0($s1)  #       num_rows = puzzle->num_rows;
        lw      $t6     4($s1)  #       num_cols = puzzle->num_cols;
        lw      $t5     8($s1)  #       max_dots = puzzle->max_dots;
        lb      $t4     16($s1) #       unsigned char* dominos_used = puzzle->dominos_used;
        move    $t3     $s6     #       t3 now has domino code
        add     $t2     $t2     $t4     # t2 has dominos_used[domino_code]
        sb      $zero   0($t2)
        mul     $t0     $s3     $t6
        add     $t0     $t0     $s4  
        add     $t0     $s2     $t0
        sb      $zero   0($t0)    
        add     $t0     $s4     1
        mul     $t1     $s3     $t6
        add     $t0     $t1     $s0  
        add     $t0     $s2     $t0
        sb      $zero   0($t0)

        return_end:
        move    $ra     $s0
        lw      $s0     0($sp)  #       RA REG
        lw      $s1     4($sp)  #       PUZZLE*
        lw      $s2     8($sp)  #       SOLUTION*
        lw      $s3     12($sp)  #      int rows
        lw      $s4     16($sp)  #      int columns
        lw      $s5     20($sp)  #      schmovement register
        lw      $s6     24($sp)  #      how many of these am i allowed to have again
        lw      $s7     28($sp)  #      wait im OUT
        add     $sp     $sp     32

        move    $v0     $zero
        jr      $ra
#       a0 is row
#       a1 is cols
#       a2 is num_cols
.globl next_row
next_row:
sub     $a2     $a2     1
bne     $a1     $a2     true_row
move    $v0     $a0
jr      $ra
true_row:
add     $v0     $a0     1
jr      $ra

#       a0 is col
#       a1 is num_cols
.globl next_col
next_col:
add     $a0     $a0	1
rem     $v0     $a0     $a1
jr      $ra
