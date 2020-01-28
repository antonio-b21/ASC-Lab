#Bigan Marian-Antonio
#Grupa 141 Semigrupa 2
#06.01.2019
#MARS

.data
    	v: .word 1 2 3 4
    	n: .word 4
    	t: .word 3
 	a: .word 2
    	c: .word 3
   	nl: .byte '\n'
.text
main:
	subu $sp, $sp, 20
	lw $t0, t
	sw $t0, 16($sp)
	lw $t0, c
  	  sw $t0, 12($sp)
  	  lw $t0, a
  	  sw $t0, 8($sp)
   	 lw $t0, n
   	 sw $t0, 4($sp)
   	 la $t0, v
   	 sw $t0, 0($sp)
  	  #$sp:(v)(n)(a)(c)(t)
  	  jal modif
  	  addu $sp, $sp, 20
  	  lw $t0, n
  	  la $t1, v

afisare:
   	 beqz $t0, exit
   	 lw $a0, 0($t1)
   	 li $v0, 1
   	 syscall
   	 lb $a0, nl
   	 li $v0, 11
   	 syscall
   	 addu $t1, $t1, 4
  	  sub $t0, $t0, 1
  	  j afisare
exit:
    	li $v0, 10
   	 syscall


modif:
   	 #$sp:(v)(n)(a)(c)(t)
   	 subu $sp, $sp, 20
  	  sw $fp, 16($sp)
   	 sw $ra, 12($sp)
   	 sw $s0, 8($sp)
   	 sw $s1, 4($sp)
   	 sw $s2, 0($sp)
   	 add $fp, $sp, 20
   	 #$sp:(s2 v)(s1 v)(s0 v)(ra v)(fp v)$fp:(v)(n)(a)(c)(t)
   	 lw $s0, 0($fp)
   	 lw $s1, 4($fp)
modifLoop1:
    	lw $s2, 0($s0)
    	lw $s3, 16($fp)
   	ble $s3, $s2, modifLoop1End
    
    	subu $sp, $sp, 12
	sw $s2, 8($sp)
	lw $s2, 12($fp)
	sw $s2, 4($sp)
	lw $s2, 8($fp)
	sw $s2, 0($sp)
	#$sp:(a)(c)(v[i])
	jal f
	addu $sp, $sp, 12
    	sw $v0, 0($s0)
modifLoop1End:
  	addu $s0, $s0, 4
	sub $s1, $s1, 1
	bnez $s1, modifLoop1

modif1:
   	 lw $s2, -20($fp)
   	 lw $s1, -16($fp)
   	 lw $s0, -12($fp)
   	 lw $ra, -8($fp)
   	 lw $fp, -4($fp)
   	 addu $sp, $sp, 20
   	 jr $ra

f:
	#$sp:(a)(c)(v[i])
	subu $sp, $sp, 12
	sw $fp, 8($sp)
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	addi $fp, $sp, 12
	#$sp:(s1 v)(s0 v)(fp v)$fp:(a)(c)(v[i])
	lw $s0, 0($fp)
	lw $s1, 8($fp)
	mul $s0, $s0, $s1
	lw $s1, 4($fp)
	rem $v0, $s0, $s1
	
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 12
	jr $ra
