.data
	n: .space 4
	sp: .byte ' '
.text
main:
	li $v0, 5
	syscall
	move $t0, $v0
	sw  $t0, n
	li $t1, 2
loop:
	bge $t1,$t0, exit
	rem $t2, $t0, $t1
	beq $t2, $0, factor
loopContinue:
	addi $t1, $t1, 1
	j loop
factor:
	move $a0, $t1
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall
	j loopContinue
exit:
	li $v0, 10
	syscall
