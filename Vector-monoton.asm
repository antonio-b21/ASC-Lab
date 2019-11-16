.data
	v: .space 400 #v[100]
	n: .space 4
	txtSuccess: .asciiz "Elementele sunt in ordine crescatoare"
	txtFail: .asciiz "Primul index gresit este "
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

	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_read
main2:
	li $t0, 1
	li $t1, 4
	lw $t3, v($0)
loop_check:
	bge $t0, $s0, success
	lw $t4, v($t1)
	ble $t4, $t3, fail
	
	move $t3, $t4
	addi $t0, $t0, 1
	addi $t1, $t1, 4
	j loop_check
success:
	la $a0, txtSuccess
	li $v0, 4
	syscall	
	j exit
fail:
	la $a0, txtFail
	li $v0, 4
	syscall
	move $a0, $t0
	li $v0, 1
	syscall
exit:
	li $v0, 10
	syscall
