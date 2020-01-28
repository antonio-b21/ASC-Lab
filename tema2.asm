.data
    v: .word 5 4 3 2 1 0 -4 6
    n: .word 8
    nl: .byte '\n'
.text
main:
    subu $sp, $sp, 8
    lw $t0, n
    sw $t0, 4($sp)
    la $t1, v
    sw $t1, 0($sp)
    #$sp:(v)(n)
    jal modifica0
    addu $sp, $sp, 8

afisare:
    beqz $t0, exit
    lw $a0, 0($t1)
    li $v0, 1
    syscall
    lb $a0, nl
    li $v0, 11
    syscall
    addu $t1, $t1, 4
    sub $t0, $t0, 1
    j afisare

exit:
    li $v0, 10
    syscall


modifica0:
    #$sp:(v)(n)
    subu $sp, $sp, 20
    sw $fp, 16($sp)
    sw $ra, 12($sp)
    sw $s0, 8($sp)
    sw $s1, 4($sp)
    sw $s2, 0($sp)
    addu $fp, $sp, 20
    #$sp:(s2 v)(s1 v)(s0 v)(ra v)(fp v)$fp:(v)(n)
    lw $s0, 0($fp)
    lw $s1, 4($fp)
    beqz $s1, modifica1
    lw $s2, 0($s0)
    
    subu $sp, $sp, 4
    sw $s2, 0($sp)
    #$sp:(x)
    jal suma_patrate0
    addu $sp, $sp, 4

    sw $v0, 0($s0)
    sub $s1, $s1, 1
    addu $s0, $s0, 4
    subu $sp, $sp, 8
    sw $s1, 4($sp)
    sw $s0, 0($sp)
    #$sp:(v)(n)
    jal modifica0
    addu $sp, $sp, 8

modifica1:
    lw $s2, -20($fp)
    lw $s1, -16($fp)
    lw $s0, -12($fp)
    lw $ra, -8($fp)
    lw $fp, -4($fp)
    addu $sp, $sp, 20
    jr $ra

suma_patrate0:
    #$sp:(x)
    subu $sp, $sp, 16
    sw $fp, 12($sp)
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)
    addu $fp, $sp, 16
    #$sp:(s1 v)(s0 v)(ra v)(fp v)$fp:(x)
    lw $s0, 0($fp)
    sgt $v0, $s0, 1
    beqz $v0, suma_patrate1
    blt $s0, 2, suma_patrate1
    
    sub $s0, $s0, 1
    subu $sp, $sp, 4
    sw $s0, 0($sp)
    #$sp:(x)
    jal suma_patrate0
    addu $sp, $sp, 4

    mul $s1, $s0, $s0
    add $v0, $v0, $s1

suma_patrate1:
    lw $s1, -16($fp)
    lw $s0, -12($fp)
    lw $ra, -8($fp)
    lw $fp, -4($fp)
    addu $sp, $sp, 16
    jr $ra
