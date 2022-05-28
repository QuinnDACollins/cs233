.globl value
value:
        sub    $sp, $sp, 36
        sw     $s0, 0($sp)
        sw     $s1, 4($sp)
        sw     $s2, 8($sp) 
        sw     $s3, 12($sp)
        sw     $s4, 16($sp)
        sw     $s5, 20($sp)
        sw     $s6, 24($sp)
        sw     $s7, 28($sp)
        sw     $ra, 32($sp)
        move    $s0, $a0                                #current_node = root_node
        lw      $s1, 0($s0)                             #load type
        move    $s2,   $s0                              #load byte bool
        add     $s2    4
        move    $s3  $s0                                #load node pointer value
        add     $s3    8
        lw      $s4, 12($s0)                            #load pointer to left node
        lw      $s5, 16($s0)                            #load pointer to right node

        bne    $a0, $zero, check_computed               #if(node==null)
        move   $v0, $zero                               #set return value to 0 
        lw     $s0, 0($sp)
        lw     $s1, 4($sp)
        lw     $s2, 8($sp) 
        lw     $s3, 12($sp)
        lw     $s4, 16($sp)
        lw     $s5, 20($sp)
        lw     $s6, 24($sp)
        lw     $s7, 28($sp)
        lw     $ra, 32($sp)
        add    $sp, $sp, 36
        jr      $ra                                     #end
check_computed:
        li      $t0, 1                                  #set $t0 to 1 for true
        lb      $t1, 0($s2)                             #set $t1 to computed
        bne     $t0, $t1, return                        #if(node->computed)

        move    $a0, $s4                                #set $a0 as left pointer to the node
        jal     value
        move    $s6, $v0                                #set value(node->left) as $s6

        move    $a0, $s5                                #set $a0 as right pointer to the node
        jal     value
        move    $s7, $v0                                #set value(node->right) as $s7
check_constant:
        li      $t0, 7                                  #constant type
        bne     $s1, $t0, check_add                     #if(node->type == 9)
        lw      $v0, 8($s0)                             #set return as node->value
        j      end
check_add:
        bne     $s1, $zero, check_sub                   #if(node->type == 0)
        add     $t1, $s6, $s7                           #add $s6 and $s7 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j       end
check_sub:
        li      $t0, 1                                  #load 1 to $t0
        bne     $s1, $t0, check_mul                     #if(node->type == 1)
        sub     $t1, $s6, $s7                           #subtract $s6 and $s7 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j end
check_mul:
        add     $t0, $t0, 1                             #update $t0 to 2
        bne     $s1, $t0, check_div                     #if(node->type == 2)
        mul     $t1, $s6, $s7                           #multiply $s6, $s7 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j end
check_div:
        add     $t0, $t0, 1                             #update $t0 to 3
        bne     $s1, $t0, check_rem                     #if(node->type == 3)
        div     $t1, $s6, $s7                           #divide $s6 with $s7 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j end
check_rem:
        add     $t0, $t0, 1                             #update $t0 to 4
        bne     $s1, $t0, check_neg                     #if(node->type == 4)
        rem     $t1, $s6, $s7                           #modulo $s6 with $s7 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j       end
check_neg:
        add     $t0, $t0, 1                             #update $t0 to 5
        bne     $s1, $t0, check_paren                   #if(node->type == 5)
        sub     $t1, $zero, $s6                         #compute -$s6 and set it to $t1
        sw      $t1, 8($s0)                             #set $t1 to the node->value
        j       end
check_paren:
        add     $t0, $t0, 1                             #update $t0 to 6
        bne     $s1, $t0, end                           #if(node->type == 6)
        sw      $s6, 8($s0)                             #set $s6 to the node->value
        j end
return:
        lw     $v0, 8($s0)                                 #move node->value to $v0

        lw     $s0, 0($sp)
        lw     $s1, 4($sp)
        lw     $s2, 8($sp) 
        lw     $s3, 12($sp)
        lw     $s4, 16($sp)
        lw     $s5, 20($sp)
        lw     $s6, 24($sp)
        lw     $s7, 28($sp)
        lw     $ra, 32($sp)
        add    $sp, $sp, 36
        jr      $ra
end:
        li      $t0, 1                                  #load 1 to $t0
        sw      $t0, 0($s2)                             #set node->computed to 1 

        lw      $v0, 8($s0)                             #set return to node->value

        lw     $s0, 0($sp)
        lw     $s1, 4($sp)
        lw     $s2, 8($sp) 
        lw     $s3, 12($sp)
        lw     $s4, 16($sp)
        lw     $s5, 20($sp)
        lw     $s6, 24($sp)
        lw     $s7, 28($sp)
        lw     $ra, 32($sp)
        add    $sp, $sp, 36
        jr      $ra