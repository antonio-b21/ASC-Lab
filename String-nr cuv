.data
	sir: .asciiz "  Sirul de   caractere   "
	sp: .byte ' '
.text
main:
	lb $t1, sir($0)
	li $t0, 1
	lb $s0, sp
	li $t3, 0
loop:
	lb $t2, sir($t0)
	beqz $t2, end
	bne $s0, $t2, continue
	beq $s0, $t1, continue
	addi $t3, $t3, 1
continue:
	addi $t0, $t0, 1
	move $t1, $t2
	j loop
end:
	beq $s0, $t1, exit
	addi $t3, $t3, 1
exit:
	move $a0, $t3
	li $v0, 1
	syscall
	li $v0, 10
	syscall
