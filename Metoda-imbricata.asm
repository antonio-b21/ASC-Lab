.data
	x: .word 5
.text
main:
	subu $sp, $sp, 4
	lw $t0, x
	sw $t0, 0($sp)
	#$sp:(x)
	jal g
	addu $sp, $sp, 4
	
	move $a0, $v1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
g:
	#$sp:(x)
	subu $sp, $sp, 12
	sw $fp, 8($sp)
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	addi $fp, $sp, 12
	#$sp:(ra v)(s0 v)(fp v)$fp:(x)
	lw $s0, 0($fp)
	addi $s0, $s0, 1
	
	subu $sp, $sp, 4
	sw $s0, 0($sp)
	#$sp:(x)
	jal f
	addu $sp, $sp, 4
	
	lw $ra, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
f:
	#$sp:(x)
	subu $sp, $sp, 8
	sw $fp, 4($sp)
	sw $s0, 0($sp)
	addi $fp, $sp, 8
	#$sp:(s0 v)(fp v)$fp:(x)
	lw $s0, 0($fp)
	
	mul $v1, $s0, 2
	
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 8
	jr $ra
