/*
Lab 5
Kyle Matsumoto and Ahmad
Lab Section 4
Lab TA: Daphne Gorman
17 March 2015
*/

.global getDelay
.global counter
.global delay
.global setup

.text
.ent getDelay
getDelay:
    la      $a0, hello  # load address of hello
    addi    $sp, $sp, -4   # decrement stack pointer
    sw      $ra, 0($sp)  # push the ra to the stack
    la      $t0, counter  # load the address of counter
    lw      $a1, 0($t0)  # load the counter number
    jal     printf   # print
    nop
    la      $t0, counter  # load the address of counter
    lw      $a1, 0($t0)  # load counter number
    addi    $a1, $a1, 1  # add 1 to the counter
    sw      $a1, counter  # store the new number

    la      $t0, PORTD  # load address of portD 
    lw      $t1, 0($t0)  # load the value of portD
    srl     $t2, $t1, 8  # shift the data right by 8 bits
                         
    la      $t3, delay  # load the address of delay
    lw      $t4, 0($t3)  # load delay into t4
    mul     $v0, $t4, $t2  # multiply the number by the input 
                           # to set the delay for each input

    lw      $ra, 0($sp)  # pop the return address from the stack
    addi    $sp, $sp, 4  # increment the stack pointer
    jr      $ra  # return to the PC before the function
    nop
.end getDelay

.ent setup
setup:
  # clear T1CON
    li      $t1, 0xFFFF
    la      $t0, T1CON
    sw      $t1, 4($t0)
  # set the prescalar
    li      $t1, 0x0030
    sw      $t1, 8($t0)
  # clear TMR1
    li      $t1, 0xFFFF
    la      $t2, TMR1
    sw      $t1, 4($t2)
  # set PR1
    la      $t3, PR1 
    li      $t4, 0x9896  
    sw      $t4, 0($t3)
  # set T1IP 
    la      $t4, IPC1
    li      $t5, 0x10
    sw      $t5, 8($t4)
  # clear T1IF
    li      $t5, 0x10
    la      $t6, IFS0
    sw      $t5, 4($t6)
  # enable T1IE 
    la      $t2, IEC0
    li      $t3, 0x10
    sw      $t3, 8($t2)
  # set T1 to ON
    la      $t0, T1CON
    li      $t7, 0x8000
    sw      $t7, 8($t0)
  # return from subroutine
    jr      $ra
    nop
.end setup

ISR:
    # activate flash
    la      $t0, PORTE
    li      $t1, 0x00FF
    sw      $t1, 0($t0)
  # clear TMR1
    li      $t2, 0xFFFF
    la      $t3, TMR1
    sw      $t2, 4($t3)
  # clear T1IF
    la      $t2, IFS0
    li      $t3, 0x0010
    sw      $t3, 4($t2)
  # re-enable T1IE
    la      $t2, IEC0
    li      $t3, 0x0010
    sw      $t3, 8($t2)
  # return
    eret
    nop

.section .vector_4, code
    j ISR
    nop

.data
hello:        .asciiz     "Hello, world! %d\n"
counter:    .word       0
delay:      .word       0xF0000  # used 0xF0000 because 0x80000 is too small
