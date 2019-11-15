.data
	x: .word 5
	y: .word 6
	z: .word 7
	nl: .asciiz " "
.text
main:
	lw $t0, z
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(z)
	lw $t0, y
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(y)(z)
	lw $t0, x
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(x)(y)(z)
	jal calcul0
	addu $sp, $sp, 12
	
	la $a0, nl
	li $v0, 4
	syscall
	move $a0, $v1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
calcul0:
	#$sp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	#$sp:(fp v)(x)(y)(z)
	addi $fp, $sp, 4
	#$sp:(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s0, 0($sp)
	#$sp:(s0 v)(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s1, 0($sp)
	#$sp:(s1 v)(s0 v)(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s2, 0($sp)
	#$sp:(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s3, 0($sp)
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s4, 0($sp)
	#$sp:(s4 v)(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)(y)(z)
	subu $sp, $sp, 4
	sw $s5, 0($sp)
	#$sp:(s5 v)(s4 v)(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)(y)(z)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	
	li $s3, 0
	li $v1, 0
	addi $s0, $s0, 1
calculLoop1:
	bgt $s3, $s0, calcul1
	div $s4, $s3, 3
	add $s4, $s4, $s2
	sub $s5, $s1, $s3
	mul $s4, $s4, $s5
	addi $s4, $s4, 1
	add $v1, $v1, $s4
	###############
	move $a0, $s4
	li $v0, 1
	syscall
	la $a0, nl
	li $v0, 4
	syscall
	###############
	addi $s3, $s3, 1
	j calculLoop1
calcul1:
	lw $s5, -28($fp)
	lw $s4, -24($fp)
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 28
	jr $ra