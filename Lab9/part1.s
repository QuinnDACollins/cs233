.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000      
TIMER_ACK               = 0xffff006c 

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

PICKUP                  = 0xffff00f4

### Puzzle
GRIDSIZE = 8
has_puzzle:        .word 0                         
puzzle:      .half 0:2000             
heap:        .half 0:2000
#### Puzzle



.text
main:
# Construct interrupt mask
	li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	          # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	mtc0    $t4, $12

#Fill in your code here
corn_detective:
        li      $a0     24  
        lw      $a1     BOT_Y($0)
        jal     down 

        li      $a0     48
        lw      $a1     BOT_X($0)       
        jal     right

        li      $a0     96
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     56
        lw      $a1     BOT_X($0)        
        jal     right

        li      $a0     8
        lw      $a1     BOT_Y($0)        
        jal     down
       
        jal     grab

        li      $a0     24
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     24
        lw      $a1     BOT_X($0)        
        jal     right

        li      $a0     24
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     88
        lw      $a1     BOT_X($0)        
        jal     right

        li      $a0     8
        lw      $a1     BOT_Y($0)        
        jal     down

        jal     grab

        li      $a0     32
        lw      $a1     BOT_Y($0)        
        jal     up

        li      $a0     16
        lw      $a1     BOT_X($0)        
        jal     left

        li      $a0     32
        lw      $a1     BOT_Y($0)        
        jal     up

        li      $a0     8
        lw      $a1     BOT_X($0)        
        jal     right

        li      $a0     40
        lw      $a1     BOT_Y($0)        
        jal     up

        li      $a0     24
        lw      $a1     BOT_X($0)        
        jal     right

        jal     grab

        li      $a0     24
        lw      $a1     BOT_X($0)        
        jal     left

        li      $a0     40
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     8
        lw      $a1     BOT_X($0)        
        jal     left

        li      $a0     128
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     64
        lw      $a1     BOT_X($0)        
        jal     right

        li      $a0     24
        lw      $a1     BOT_Y($0)        
        jal     down

        li      $a0     16
        lw      $a1     BOT_X($0)        
        jal     right

        jal     grab

        li      $t0     0
        sw      $t0     VELOCITY($zero)     # drive
left:
        sub     $t2     $a1     $a0
        li      $t0     10
        sw      $t0     VELOCITY($zero)     # drive

        li      $t0     180
        sw      $t0     ANGLE($zero)     # drive
        li      $t0     1
        sw      $t0     ANGLE_CONTROL($zero)     # drive

        lw      $t1     BOT_X($zero) 
        bgt     $t1     $t2     left
        jr      $ra
right:
        add     $t2     $a0     $a1
        li      $t0     10
        sw      $t0     VELOCITY($zero)     # drive

        li      $t0     0
        sw      $t0     ANGLE($zero)     # drive
        li      $t0     1
        sw      $t0     ANGLE_CONTROL($zero)     # drive

        lw      $t1     BOT_X($zero) 
        blt     $t1     $t2     right
        jr      $ra
up:
        sub     $t2     $a1     $a0
        li      $t0     10
        sw      $t0     VELOCITY($zero)     # drive

        li      $t0     270
        sw      $t0     ANGLE($zero)     # drive
        li      $t0     1
        sw      $t0     ANGLE_CONTROL($zero)     # drive

        lw      $t1     BOT_Y($zero) 
        bgt     $t1     $t2     up
        jr      $ra
down:
        add     $t2     $a0     $a1
        li      $t0     10
        sw      $t0     VELOCITY($zero)     # drive

        li      $t0     90
        sw      $t0     ANGLE($zero)     # drive
        li      $t0     1
        sw      $t0     ANGLE_CONTROL($zero)     # drive

        lw      $t1     BOT_Y($zero) 
        blt     $t1     $t2     down
        jr      $ra
grab:
        li      $t0     0
        sw      $t0     VELOCITY($zero)     # drive
        li      $t1     1
        sw      $t1     PICKUP($zero)
        li      $t1     0
        sw      $t1     PICKUP($zero)
        jr      $ra
infinite:
        j       infinite              # Don't remove this! If this is removed, then your code will not be graded!!!

.kdata
chunkIH:    .space 8  #TODO: Decrease this
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        j   interrupt_dispatch
non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
