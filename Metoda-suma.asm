.data
	x: .word 3
	y: .word 6
.text
main:
	subu $sp, $sp, 8
	lw $t0, y
	sw $t0, 4($sp)
	lw $t0, x
	sw $t0, 0($sp)
	#$sp:(x)(y)
	jal sum0
	addu $sp, $sp, 8
	
	move $a0, $v1
	li $v0, 1
	syscall	
	li $v0, 10
	syscall
sum0:
	#$sp:(x)(y)
	subu $sp, $sp, 12
	sw $fp, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	addi $fp, $sp, 12
	#$sp:(s1 v)(s0 v)(fp v)$fp:(x)(y)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	
	add $v1, $s0, $s1
	
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
