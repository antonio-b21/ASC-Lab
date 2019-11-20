.data
	v: .word 5, 35, 8, 12
	n: .word 4
	sp: .asciiz " "
.text
main:
	subu $sp, $sp, 8
	lw $t0, n
	sw $t0, 4($sp)
	la $t0, v
	sw $t0, 0($sp)
	#$sp:(v)(n)
	jal modifica0
	addu $sp, $sp, 8
	
	li $t0, 0
	lw $s0, n
loop:
	mul $t1, $t0, 4
	lw $a0, v($t1)
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	blt $t0, $s0, loop
	li $v0, 10
	syscall
modifica0:
	#$sp:(v)(n)
	subu $sp, $sp, 20
	sw $fp, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 20
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(v)(n)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	li $s3, 0
modificaLoop0:
	lw $s2, 0($s0)
	addi $s2, $s2, 1
	sw $s2, 0($s0)
	addu $s0, $s0, 4
	addi $s3, $s3, 1
	blt $s3, $s1, modificaLoop0
	
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 20
	jr $ra
