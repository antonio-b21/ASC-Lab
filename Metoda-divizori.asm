.data
	n: .space 4
	divs: .space 60
	sp: .byte ' '
.text
main:
	li $v0, 5
	syscall
	sw  $v0, n
	
	subu $sp, $sp, 8
	lw $t0, n
	sw $t0, 0($sp)
	la $t0, divs
	sw $t0, 4($sp)
	#$sp:(n)(divs)(ra v)
	jal divisors0
	addu $sp, $sp, 8
	
	li $v0, 10
	syscall
	
divisors0:
	#$sp:(n)(divs)
	subu $sp, $sp, 20
	sw $fp, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 20
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(n)(divs)
	lw $s0, 4($fp)
	lw $s1, 0($fp)
	li $s2, 2
	li $v1, 0
divisorsLoop1:
	bge $s2, $s1, divisors1
	rem $s3, $s1, $s2
	bnez $s3, divisorsLoop1End
	
	move $a0, $s2
	li $v0, 1
	syscall
	
	sw $s2, 0($s0)
	addu $s0, $s0, 4
	addi $v1, $v1, 4
divisorsLoop1End:
	addi $s2, $s2, 1
	j divisorsLoop1
divisors1:
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 20
	jr $ra