.data
	x: .word 13
.text
main:
	lw $t0, x
	subu $sp, $sp, 4
	sw $t0, 0($sp)
	#$sp:(x)
	jal prim0
	addu $sp, $sp, 4
	move $a0, $v1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
prim0:
	#$sp:(x)
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	#$sp:(fp v)(x)
	addi $fp, $sp, 4
	#$sp:(fp v)$fp:(x)
	subu $sp, $sp, 4
	sw $s0, 0($sp)
	#$sp:(s0 v)(fp v)$fp:(x)
	subu $sp, $sp, 4
	sw $s1, 0($sp)
	#$sp:(s1 v)(s0 v)(fp v)$fp:(x)
	subu $sp, $sp, 4
	sw $s2, 0($sp)
	#$sp:(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)
	lw $s0, 0($fp)
	ble $s0, 1, primIf1
	li $s1, 2
	li $v1, 1
primLoop1:
	bge $s1, $s0, prim1
	rem $s2, $s0, $s1
	beqz $s2, primIf1
	addi $s1, $s1, 1
	j primLoop1
primIf1:
	li $v1, 0
prim1:
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 16
	jr $ra
