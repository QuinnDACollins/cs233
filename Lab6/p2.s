# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
    sub  $sp $sp, 24
    sw   $s5  0($sp)   # save return address
    sw   $s0  4($sp)   # save the array pointer arg [int] 
    sw   $s1  8($sp)   # save the length arg [int]
    sw   $s2 12($sp)   # prepare a [s] register to save our min_idx
    sw   $s3 16($sp)   # prepare a [s] register to save our i
    sw   $s4 20($sp)   # prepare a [s] register to save our j
    add  $s3  -1
    move $s0  $a0      # prep compare
    move $s1  $a1      # prep compare 
    move $s5  $ra
    loop:
        add  $s3  1        # i++
        sub  $t0  $s1  1   # store length - 1 into 0[t] register  
        bge  $s3  $t0  clean_up  # i < len -1
        add  $s2  $s3  $0  #  min_idx = i
        add  $s4  $s3  $0  # j = i
       
    inner_loop:
        add  $s4  $s4  1  # j = i + 1
        bge  $s4  $s1  if   # j < len


        mul  $t4  $s4  4  # quadrupling index for j
        add  $t4  $t4  $s0  # add quadrupled index to array pointer to get array[i]
        lw   $t3  0($t4)    # tmp = array[j]

        mul  $t5  $s2  4  # quadrupling index for min_idx
        add  $t5  $t5  $s0  # add quadrupled index to array pointer to get array[min_idx]
        lw   $t1  0($t5)    # tmp = array[min_idx]

        move $a0  $t3      # prep compare
        move $a1  $t1      # prep compare 

        jal compare           # compare(array[j], array[min_idx])

        beq $v0  $0  inner_loop    # if (compare(array[j], array[min_idx]))
        add  $s2  $s4  $0  #  min_idx = j
        j inner_loop
        
    if:
        beq  $s2  $s3  loop

        mul  $t4  $s3  4 # quadrupling index for i
        add  $t4  $t4  $s0  # add quadrupled index to array pointer to get array[i]
        lw   $t3  0($t4)    # tmp = array[i]

        mul  $t5  $s2  4  # quadrupling index for min_idx
        add  $t5  $t5  $s0  # add quadrupled index to array pointer to get array[min_idx]
        lw   $t1  0($t5)    # min idx

        sw   $t1  0($t4)    # array[i] = array[min_idx]
        sw   $t3  0($t5)    # array[min_idx] = tmp
        
        j loop

    clean_up:
        move $ra $s5
        add  $sp  $sp  24  
        lw   $s5  0($sp)   # save return address
        lw   $s0  4($sp)   # save the array pointer arg [int] 
        lw   $s1  8($sp)   # save the length arg [int]
        lw   $s2 12($sp)   # prepare a [s] register to save our min_idx
        lw   $s3 16($sp)   # prepare a [s] register to save our i
        lw   $s4 20($sp)   # prepare a [s] register to save our j
        
        jr      $ra



# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) {
#       char orig = map[i][j].repr;
#
#       if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#       if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#       if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#       if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#       if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }

#       if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:
    jr      $ra

.globl grad

grad:
    sub     $t0, $a0, -1
    sub     $t1, $a1, -1
    mul     $t2, $t0, $a0   # lhs * (lhs - 1)
    mul     $t3, $t1, $a1   # rhs * (rhs - 1)
    blt     $t2, $t3, less_than
    li      $v0, 0
    jr      $ra
