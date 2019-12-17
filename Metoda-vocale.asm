.data
	str: .asciiz "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMONPQRSTUVWXYZ"
	el: .byte '\0'
	vow: .asciiz "aeiouAEIOU"
.text
main:
	subu $sp, $sp, 4
	la $t0, str
	sw $t0, 0($sp)
	#$sp:(str)
	jal vocale0
	addu $sp, $sp, 4
	
	li $v0, 10
	syscall
vocale0:
	#$sp:(str)
	subu $sp, $sp, 24
	sw $fp, 20($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $ra, 0($sp)
	addi $fp, $sp, 24
	#$sp:(ra v)(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(str)
	lw $s0, 0($fp)
	lb $s1, el
vocaleLoop1:
	lb $s2, 0($s0)
	
	subu $sp, $sp, 4
	sw $s2, 0($sp)
	#$sp:(str[i])
	jal eVocala0
	addu $sp, $sp, 4
	
	beqz $v1, vocaleLoop1Continue
	move $a0, $s2
	li $v0, 11
	syscall
vocaleLoop1Continue:
	addu $s0, $s0, 1
	bne $s2, $s1, vocaleLoop1
	
	lw $ra, -24($fp)
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 24
	jr $ra
eVocala0:
	#$sp:(str[i])
	subu $sp, $sp, 20
	sw $fp, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 20
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(str[i])
	lw $s0, 0($fp)
	la $s1, vow
	lb $s2, el
	li $v1, 0
eVocalaLoop1:
	lb $s3, 0($s1)
	beq $s3, $s2, eVocala1
	beq $s0, $s3, eVocalaIf1
	addu $s1, $s1, 1
	j eVocalaLoop1
eVocalaIf1:
	li $v1, 1
eVocala1:
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 20
	jr $ra
