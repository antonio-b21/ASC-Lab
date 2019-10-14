.data
	n: .space 4
	sum: .word 0
	txt1: .asciiz "Media aritmetica"
	txt2: .asciiz "\nCatul:"
	txt3: .asciiz "\nRestul"
.text
main:
	li $v0, 5
	syscall
	move $t0, $v0
	sw  $t0, n
	li $t1, 0
loop:
	bge $t1,$t0, exit

	li $v0, 5
	syscall
	lw $t2, sum
	add $t2, $t2, $v0
	sw $t2, sum

	addi $t1, $t1, 1
	j loop
exit:
	lw $t1, sum
	div $t2, $t1, $t0
	rem $t3, $t1, $t0

	la $a0, txt1
	li $v0, 4
	syscall

	la $a0, txt2
	li $v0, 4
	syscall
	move $a0, $t2
	li $v0, 1
	syscall

	la $a0, txt3
	li $v0, 4
	syscall
	move $a0, $t3
	li $v0, 1
	syscall
	

li $v0, 10
syscall
