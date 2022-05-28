# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:
    move   $t1, $a1   #array pointer
    li     $t2, 0
    inner:
        
        li    $t3,  6          # Load our 6 into the temp for the condition
        bge    $t2, $t3, end
        
        srl    $a0, $a0, 3     # request >>= 3
        li     $t3, 3       # load $t1 = 3
        div    $t4, $t2, $t3   # $t0 = {hi}{lo} i / 3
        mfhi   $t4             # $t0 = i % 3
        bne    $t4, $0, else   # if i % 3 == 0
        
        # $t3, t4 free, $t5 free

        add    $t3, $t2, $t2   # double our idnex
        add    $t3, $t3, $t3   # quadruple our index (ints)
        add    $t5, $t1, $t3   # Load our array address + index * 4 into $t2

        # $t3 free
        and    $t4, $a0, 31    # request & 00000001f -> $t3
        sw     $t4, 0($t5)     # $t1 -> array[i]
        add    $t2, 1          # ++i
        j inner
    else:
        add    $t3, $t2, $t2   # double our idnex
        add    $t3, $t3, $t3   # quadruple our index (ints)
        add    $t5, $t1, $t3   # Load our array address + index * 4 into $t2

        # $t3 free
        and    $t4, $a0, 255    # request & 00000001f -> $t3
        sw     $t4, 0($t5)     # $t1 -> array[i]
        add    $t2, 1          # ++i
        j inner
    end:
        jr    $ra
