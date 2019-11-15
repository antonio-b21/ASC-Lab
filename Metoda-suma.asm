.data
	x: .word 3
	y: .word 6
.text
main:
	lw $t0, y
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(y)
	lw $t0, x
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(x)(y)
	jal sum
	addu $sp, $sp, 8
	move $a0, $v0
	li $v0, 1
	syscall
	li $v0, 10
	syscall
sum:
	#$sp:(x)(y)
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	#$sp:(fp v)(x)(y)
	addi $fp, $sp, 4
	#$sp:(fp v)$fp:(x)(y)
	subu $sp, $sp, 4
	sw $s0, 0($sp)
	#$sp:(s0 v)(fp v)$fp:(x)(y)
	subu $sp, $sp, 4
	sw $s1, 0($sp)
	#$sp:(s1 v)(s0 v)(fp v)$fp:(x)(y)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	add $v0, $s0, $s1
	lw $s1 -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
