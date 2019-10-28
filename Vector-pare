.data
	v: .space 400 #v[100]
	n: .space 4
	sp: .asciiz " "
.text
read_n:
	li $v0, 5
	syscall
	sw $v0, n
main:
	lw $s0, n
	li $t0, 0
	li $t1, 0

loop_read:
	bge $t0, $s0, main2
	li $v0, 5
	syscall
	sw $v0, v($t1)

	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_read
main2:
	li $t0, 0
	li $t1, 0
loop_write:
	bge $t0, $s0, exit
	lw $t2, v($t1)
	rem $t3, $t2, 2
	beqz $t3, write
continue_write:
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_write
write:	
	move $a0, $t2
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall
	j continue_write
exit:
	li $v0, 10
	syscall
