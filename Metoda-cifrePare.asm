.data
	x: .word 1234567890
.text
main:
	subu $sp, $sp, 4
	lw $t0, x
	sw $t0, 0($sp)
	#$sp:(x)
	jal evenDigits0
	addu $sp, $sp, 4
	
	li $v0, 10
	syscall
evenDigits0:
	#$sp:(x)
	subu $sp, $sp, 4
	sw $fp, 0($sp)
	#$sp:(fp v)(x)
	#lw $fp, 4($sp)
	addi $fp, $sp, 4
	#$sp:(fp v)$fp:(x)
	subu $sp, $sp, 4
	sw $s0, 0($sp)
	#$sp:(s0 v)(fp v)$fp:(x)
	subu $sp, $sp, 4
	sw $s1, 0($sp)
	#$sp:(s1 v)(s0 v)(fp v)$fp:(x)
	lw $s0, 0($fp)
evenDigitsLoop1:
	blez $s0, evenDigits1
	rem $s1, $s0, 2
	beqz $s1 evenDigitsIf1
evenDigitsLoop1Continue1:
	div $s0, $s0, 10
	j evenDigitsLoop1
evenDigitsIf1:
	rem $a0, $s0, 10
	li $v0, 1
	syscall
	j evenDigitsLoop1Continue1
evenDigits1:
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
