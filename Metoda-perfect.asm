.data
	n: .word 9
.text
main:
	subu $sp, $sp, 4
	lw $t0, n
	sw $t0, 0($sp)
	#$sp:(n)
	jal perfect0
	addu $sp, $sp, 4
	
	move $a0, $v1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
perfect0:
	#$sp:(n)
	subu $sp, $sp, 16
	sw $fp, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	addi $fp, $sp, 16
	#$sp:(s2 v)(s1 v)(s0 v)(fp v)$fp:(n)
	lw $s0, 0($fp)
	li $s1, 1
perfectLoop1:
	addi $s1, $s1, 1
	mul $s2, $s1, $s1
	blt $s2, $s0, perfectLoop1
	
	seq $v1, $s2, $s0
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 16
	jr $ra
