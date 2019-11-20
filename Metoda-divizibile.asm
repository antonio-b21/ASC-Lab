.data
	a: .word 12
	b: .word 21
	x: .word 3
.text
main:
	subu $sp, $sp, 12
	lw $t0, x
	sw $t0, 8($sp)
	lw $t0, b
	sw $t0, 4($sp)
	lw $t0, a
	sw $t0, 0($sp)
	#$sp:(a)(b)(x)
	jal divizibile0
	addu $sp, $sp, 12
	
	move $a0, $v1
	li $v0, 1
	syscall
	li $v0, 10
	syscall
divizibile0:
	#$sp:(a)(b)(x)
	subu $sp, $sp, 20
	sw $fp, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 20
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(a)(b)(x)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	li $v1, 0
divizibileLoop1:
	rem $s3, $s0, $s2
	seq $s3, $s3, 0
	add $v1, $v1, $s3
	addi $s0, $s0, 1
	ble $s0, $s1, divizibileLoop1

	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 20
	jr $ra
