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
	li $t2, 0
loop_read:
	bge $t0, $s0, main2
	li $v0, 5
	syscall
	sw $v0, v($t1)
	lw $t3, v($t1)
	bgt $t3, $t2, new_max
continue_read:
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_read
new_max:
	move $t2, $t3
	j continue_read
main2:
	li $t0, 0
	li $t1, 0
loop_write:
	bge $t0, $s0, exit
	lw $t3, v($t1)
	beq $t3, $t2, write
continue_write:
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_write
write:
	move $a0, $t0
	li $v0, 1
	syscall
	la $a0, sp
	li $v0, 4
	syscall
	j continue_write
exit:
	li $v0, 10
	syscall
