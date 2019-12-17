.data
	v: .space 100 #v[100]
	w: .space 100
	n: .space 4
	sp: .asciiz " "
.text
main:
	li $v0, 5
	syscall
	sw $v0, n
	lw $s0, n
	li $t0, 0
	li $t1, 0
loop_read:
	bge $t0, $s0, main2
	li $v0, 5
	syscall
	sw $v0, v($t1)

	add $t0, $t0, 1
	add $t1, $t1, 4
	j loop_read
main2:
	subu $sp, $sp, 8
	lw $t0, n
	sw $t0, 4($sp)
	la $t0, v
	sw $t0, 0($sp)
	#$sp:(v)(n)
	jal numerePrime0
	addu $sp, $sp, 8


	li $t0, 0
loop_write:
	lw $a0, w($t0)
	beqz, $a0, exit
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall

	add $t0, $t0, 4
	j loop_write
exit:
	li $v0, 10
	syscall

numerePrime0:
	#$sp:(v)(n)
	subu $sp, $sp, 24
	sw $fp, 20($sp)
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 24
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(ra v)(fp v)$fp:(v)(n)
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	la $s2, w
numerePrimeLoop1:
	beqz $s1, numerePrime1
	lw $s3, 0($s0)
	
	subu $sp, $sp, 4
	sw $s3, 0($sp)
	#$sp:(x)
	jal prim0
	addu $sp, $sp, 4
	
	beqz $v1, numerePrimeLoop1Continue
	sw $s3, 0($s2)
	addu $s2, $s2, 4
numerePrimeLoop1Continue:
	sub $s1, $s1, 1
	addu $s0, $s0, 4
	j numerePrimeLoop1
numerePrime1:
	
	lw $s3, -24($fp)
	lw $s2, -20($fp)
	lw $s1, -16($fp)
	lw $s0, -12($fp)
	lw $ra, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 24
	jr $ra

prim0:
	#$sp:(x)
	subu $sp, $sp, 16
	sw $fp, 12($sp)
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	addi $fp, $sp, 16
	#$sp:(s2 v)(s1 v)(s0 v)(fp v)$fp:(x)
	lw $s0, 0($fp)
	li $s1, 2
	sgt $v1, $s0, 1
	beqz $v1, prim1
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