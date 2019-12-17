.data
	n: .space 4
	x: .word 2
	y: .word 3
	z: .word 4
	v: .space 100 #v[100]
	sp : .asciiz " "
.text
main:
	li $v0, 5
	syscall
	sw $v0, n
	lw $t0, n
	li $t1, 0
loop_read:
	beqz $t0 main2
	li $v0, 5
	syscall
	sw $v0, v($t1)

	sub $t0, $t0, 1
	add $t1, $t1, 4
	j loop_read
main2:
	subu $sp, $sp, 20
	lw $t0, z
	sw $t0, 16($sp)
	lw $t0, y
	sw $t0, 12($sp)
	lw $t0, x
	sw $t0, 8($sp)
	lw $t0, n
	sw $t0, 4($sp)
	la $t0, v
	sw $t0, 0($sp)
	#$sp:(v)(n)(x)(y)(Z)
	jal formula0
	lw $a0, -4($sp)
	addu $sp, $sp, 20

	li $v0, 1
	syscall
exit:
	li $v0, 10
	syscall


formula0:
	#$sp:(v)(n)(x)(y)(z)
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s0, 20($sp)
	sw $s1, 16($sp)
	sw $s2, 12($sp)
	sw $s3, 8($sp)
	sw $s4, 4($sp)
	sw $s5, 0($sp)
	addi $fp, $sp, 32
	#$sp:(s5 v)(s4 v)(s3 v)(s2 v)(s1 v)(s0 v)(ra v)(fp v)$fp:(v)(n)(x)(y)(z)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	li $s2, 0
	li $v1, 0
formulaLoop1:
	beq $s1, $s2, formula1
	lw $s3, 16($fp)
	div $s3, $s3, 3
	lw $s4, 12($fp)
	sub $s3, $s4, $s3
	add $s3, $s3, $s2
	mul $s4, $s3, $s3
	mul $s3, $s3, $s4
	lw $s4, 0($s0)
	lw $s5, 8($fp)
	rem $s5, $s4, $s5
	add $s3, $s3, $s5
	subu $sp, $sp, 4
	sw $s4, 0($sp)
	jal digitSumEven0
	addu $sp, $sp, 4
	move $s4, $v0
	seq $s4, $s4, 0
	mul $s3, $s3, $s4
	add $v1, $v1, $s3
	addu $s0, $s0, 4
	addi $s2, $s2, 1
	j formulaLoop1
formula1:
	lw $s5, -32($fp)
	lw $s4, -28($fp)
	lw $s3, -24($fp)
	lw $s2, -20($fp)
	lw $s1, -16($fp)
	lw $s0, -12($fp)
	lw $ra, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 32
	sw $v1, -4($sp)
	jr $ra

digitSumEven0:
	#$sp:(z)
	subu $sp, $sp, 12
	sw $fp, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	addi $fp, $sp, 12
	#$sp:(s1 v)(s0 v)(fp v)$fp:(z)
	lw $s0, 0($fp)
	li $v0, 0
digitSumEvenLoop1:
	beqz $s0, digitSumEven1
	rem $s1, $s0, 10
	add $v0, $v0, $s1
	div $s0, $s0, 10
	j digitSumEvenLoop1
digitSumEven1:
	rem $v0, $v0, 2
	seq $v0, $v0, 0
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
