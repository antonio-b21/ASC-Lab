.data
	a: .word 1, 2, 3, 4
	   .word 5, 6, 7, 8
	   .word 9,10,11,12
	n: .word 3
	m: .word 4
	sp: .asciiz " "
	nl: .asciiz "\n"
.text
main:
	lw $s0, n
	lw $s1, m
	li $t0, 0
loop_n:
	bge $t0, $s0, exit
	li $t1, 0
loop_m:
	bge $t1, $s1, loop_nContinue
	mul $t2, $t0, $s1
	add $t2, $t2, $t1
	mul $t2, $t2, 4
	
	lw $a0, a($t2)
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1
	j loop_m
loop_nContinue:
	la $a0, nl
	li $v0, 4
	syscall
	addi $t0, $t0, 1
	j loop_n
exit:
	li $v0, 10
	syscall
