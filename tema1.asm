.data
	p: .space 4 # numarul citit de la tastatura
	g: .space 4 # generatorul lui Zp*
	pos: .space 120 # vectorul care stocheaza izomorfismul f
	nl: .byte '\n'
	input1 : .space 11 # mesajul citit de la tastatura care va fi criptat
	input2 : .space 11 # mesajul citit de la tastatura care va fi decriptat
	letters: .asciiz "abcdefghijklmnopqrstuvwxyz{|}~" # alfabetul de lucru
	notPrimeMsg: .asciiz "Numarul nu este prim"
	generatorMsg: .asciiz "Generatorul g este: "
	encryptionMsg: .asciiz "Mesajul criptat este: "
	decryptionMsg: .asciiz "Mesajul decriptat este: "
.text
main:
	li $v0, 5
	syscall # citesc p si il salvez in memorie
	sw $v0, p
	la $a0, input1
	li $a1, 10
	li $v0, 8
	syscall # citesc sirul input1 de lungime maxima 10 si il salvez in memorie
	la $a0, input2
	li $a1, 10
	li $v0, 8
	syscall # citesc sirul input2 de lungime maxima 10 si il salvez in memorie
	
	jal prime # apel catre functia ce verifica daca p este prim
   # am folosit acest jal ca sa nu pun aici toate mutarile si realocarile din stiva
	bnez $v1, isPrime # daca functia nu returneaza 0 atunci p este prim si continui
	
	la $a0, notPrimeMsg
	li $v0, 4
	syscall # afisez un mesaj care spune ca p nu este prim
	li $v0, 10
	syscall # si inchei executia programului

isPrime: # cazul in care p este prim, trebuie sa caut generatorul
	jal generator # apel catre functia ce cauta generatorul lui Zp*
	sw $v1, g # functia returneaza in v1 generatorul si il salvez in g
	la $a0, generatorMsg
	li $v0, 4
	syscall # afisez "mesaj generator"
	lw $a0, g
	li $v0, 1
	syscall # afisez generatorul

encryption: # aici criptez mesajul
	lb $a0, nl
	li $v0, 11
	syscall # afisez un rand nou
	la $a0, encryptionMsg
	li $v0, 4
	syscall # afisez "mesaj criptat"
	
	lb $t9, nl # caracterul '\n'
	li $t0, 0 # pe post de i in iterarea prin literele stringului input1
encryptionLoop1: # bucla care itereaza prin input1
	lb $t1, input1($t0) # input1[i]
	beq $t1, $t9, decryption # daca input1[i] == '\n' am ajuns la sfarsitul lui input1

	li $t2, 0 # pe post de j in iterarea prin alfabetul de lucru
encryptionLoop2: # bucla care itereaza prin letters
	lb $t3, letters($t2) # letters[j]
	beqz $t3, encryptionLoop1End # daca letters[j] == '\0' atunci s-a epuizat alfabetul
	beq $t3, $t1, encryptionLoop1End # daca letters[j] == input[i]
        # atunci am gasit pozitia lui input[i] in letters: j($t2)
	addi $t2, $t2, 1 # j += 1
	j encryptionLoop2 # sfarsitul buclei encryptionLoop2

encryptionLoop1End: # partea de sfarsit a buclei care itereaza prin input1
	mul $t2, $t2, 4 # j *= 4, pentru a accesa intregi dintr-un vector din memorie
	lw $t2, pos($t2) # f(j)
	lb $t2, letters($t2) # letters[f(j)]
	move $a0, $t2
	li $v0, 11
	syscall # afisez letters[f(j)]
	addi $t0, $t0, 1 # i =+ 1
	j encryptionLoop1 # sfarsitul buclei encryptionLoop1

decryption: # aici decriptez mesajul
	lb $a0, nl
	li $v0, 11
	syscall # afisez un rand nou
	la $a0, decryptionMsg
	li $v0, 4
	syscall # afisez "mesaj decriptat"
	
	lb $t9, nl # caracterul '\n'
	li $t0, 0 # pe post de i in iterarea prin literele stringului input2
decryptionLoop1: # bucla care itereaza prin input2
	lb $t1, input2($t0) # input2[i]
	beq $t1, $t9, end # daca input2[i] == '\n' am ajuns la sfarsitul lui input2
	
	li $t2, 0 # pe post de j in iterarea prin alfabetul de lucru
decryptionLoop2: # bucla care itereaza prin letters
	lb $t3, letters($t2) # letters[j]
	beqz $t3, decryptionLoop1Continue # daca letters[j] == '\0', am epuizat alfabetul
	beq $t3, $t1, decryptionLoop1Continue # daca letters[j] == inout2[i]
       # atunci am gasit pozitia lui input2[i] in letters: j($t2)
	addi $t2, $t2, 1 # j += 1
	j decryptionLoop2 # sfarsitul buclei decryptionLoop2

decryptionLoop1Continue: # partea de mijloc a buclei care itereaza prin input2
	li $t3, 0 # pe post de k in iterarea prin izomorfismul f
decryptionLoop3: # bucla care itereaza prin pos
	lw $t4, pos($t3) # pos[k]
	beqz $t4, decryptionLoop1End # daca pos[k] == 0
   # atunci am epuizat imaginea izomorfismului f
	beq $t4, $t2, decryptionLoop1End # daca pos[k] == j atunci k = [f(j)]^(-1)
	addi $t3, $t3, 4 # k += 4, deoarece pos este vector de intregi
	j decryptionLoop3 # sfarsitul buclei decryptionLoop3

decryptionLoop1End: # partea de sfarsit a buclei care itereaza prin input2
	div $t2, $t3, 4 # k /= 4, deoarece k parcurgea pos=vector de intregi
           # iar acum este folosit intr-un string=vector de octeti
	lb $t2, letters($t2) # letters[k], adica letters[[f(j)]^(-1)]
	move $a0, $t2
	li $v0, 11
	syscall # afisez letters[k], adica letters[[f(j)]^(-1)]
	addi $t0, $t0, 1 # i += 1
	j decryptionLoop1 # sfarsitul buclei decryptionLoop1

end: # sfarsitul programului
	li $v0, 10
	syscall # inchei executia programului


prime: # bucata de cod care apeleaza functia ce verifica daca p e prim
	subu $sp, $sp, 8 # aloc spatiu in stiva
	lw $t0, p
	sw $t0, 0($sp) # si salvez in stiva numarul p
	sw $ra, 4($sp) # si adresa de intoarcere a bucatii de cod prime
	#$sp:(p)(ra v)
	jal prime0 # apelez functia
	lw $ra, 4($sp) # restaurez adresa de intoarcere
	addu $sp, $sp, 8 # realoc spatiul de pe stiva
	jr $ra # si ma intorc la adresa de la care a fost apelata prime

prime0: # partea de inceput a procedurii prime
	#$sp:(p)
	subu $sp, $sp, 20 # aloc spatiu pe stiva
	sw $fp, 16($sp) # si copiez registrii pe care ii voi folosi
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	addi $fp, $sp, 20 # mut referinta cadrului pentru a imi arata doar parametri
	#$sp:(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(p)
	lw $s0, 0($fp) # p
	sgt $v1, $s0, 1 # daca p < 2 returnez 0, altfel presupun prin absurd ca p este prim
	div $s3, $s0, 2 # p/2
	beqz $v1, prime1 # si sar la partea de sfarsit a procedurii prime daca p < 2

	li $s1, 2 # pe post de i care itereaza in intervalul [2, p/2], verificand daca i divide p
primeLoop1: # bucla care itereaza in numerele intregi din intervalul [2,p/2]
	bgt $s1, $s3, prime1 # daca i > p/2 atunci sar la partea de sfarsit a procedurii prime
	rem $s2, $s0, $s1 # r = p % i
	beqz $s2, primeIf1 # daca r == 0 atunci i divide p
	addi $s1, $s1, 1 # i += 1
	j primeLoop1 # sfarsitul buclei primeLoop1

primeIf1: # cazul in care am gasit primul divizor propriu al lui p
	li $v1, 0 # returnez 0 deoarece p are cel putin un divizor propriu
prime1: # partea de sfarsit a procedurii prime
	lw $s3, -20($fp) # restitui valorile vechi ale registrilor folositi
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 20 # realoc spatiul folosit de pe sitva
	jr $ra # si sar la adresa de la care a fost apelata procedura

generator: # bucata de cod care apeleaza functia ce cauta generatorul lup Zp*
	subu $sp, $sp, 12 # aloc spatiu in stiva pentru parametrii
	lw $t0, p
	sw $t0, 0($sp) # p- numar prim
	la $t0, pos
	sw $t0, 4($sp) # pos- vector care stocheaza izomorfismul f
	sw $ra, 8($sp) # si adresa de intoarcere a bucatii de cod generator
	#$sp:(p)(pos)(ra v)
	jal generator0 # apelez functia ce cauta generatorul lui Zp*
	lw $ra, 8($sp) # restitui adresa de intoarcere
	addu $sp, $sp, 12 # realoc spatiul folosit de pe stiva
	jr $ra # si sar la adresa de intoarcere de unde a fost apelata generator

generator0: # partea de inceput a functiei generator
	#$sp:(p)(pos)
	subu $sp, $sp, 32 # aloc spatiu in stiva
	sw $fp, 28($sp) # si copiez registrii pe care ii voi folosi
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $s2, 16($sp)
	sw $s3, 12($sp)
	sw $s4, 8($sp)
	sw $s5, 4($sp)
	sw $ra, 0($sp)
	addi $fp, $sp, 32 # mut referinta cadrului pentru a imi arata doar parametrii
	#$sp:(ra v)(s5 v)(s4 v)(s3 v)(s2 v)(s1 v)(s0 v)(fp v)$fp:(p)(pos)
	lw $s0, 0($fp) # p
	lw $s5, 4($fp) # pos, construiesc vectorul pe masura ce caut generatorul
	li $s2, 1
	sw $s2, 0($s5) # pos[0] = 1, deoarece g^0 = 1 pentru orice g
	seq $v1, $s0, 2 # daca p ==2 atunci g = 1, fiind singura varianta, altfel g = 0
	beq $v1, 1, generator1 # deoarece l-am gasit pe g, sar la partea de sfarsit a procedurii generator
	
	sub $s2, $s0, 1 # p-1
	li $s1, 2 # pe post de i care itereaza in intervalul [2, p-1]
  # verificand daca i este generator al lui Zp*
generatorLoop1: # bucla care itereaza in numerele intregi din intervalul [2,p-1]
	li $s4, 1 #  b = i^0
	lw $s5, 4($fp) # pos[k] (k=0)
	addu $s5, $s5, 4 # pos[k] (k=1)

	li $s3, 1 # pe post de j care itereaza in intervalul [1, p-2], verificand daca (i^j)%p == 1
generatorLoop2: # bucla care itereaza in numerele intregi din intervalul [1,p-2]
	mul $s4, $s4, $s1 # b *= i
	rem $s4, $s4, $s0 # r = b%p
	beq $s4, 1, generatorLoop1End # daca r = 1 atunci i nu este generator
    # si sar la partea de sfarsit a buclei generatorLoop1
	sw $s4, 0($s5) # pos[k] = r = (i^j)%p
	addu $s5, $s5, 4 # pos[k] (k += 1)
	addi $s3, $s3, 1 # j += 1
	blt $s3, $s2, generatorLoop2 # sfarsitul buclei generatorLoop2

		# daca am ajuns aici inseamna ca l-am gasit pe g
	li $s2, 1
	sw $s2, 0($s5) # pos[k] = 1 (k = p-1)
	move $v1, $s1 # returnez g = i
	j generator1 # l-am gasit pe g deci sar la partea de sfarsit a procedurii generator

generatorLoop1End: # partea de sfarsit a buclei generatorLoop1
	addi $s1, $s1, 1 # i += 1
	blt $s1, $s0, generatorLoop1 # sfarsitul buclei generatorLoop1 
	
generator1: # partea de sfarsit a procedurii generator
	lw $ra, -32($fp) # restitui valorile vechi ale registrilor folositi
	lw $s5, -28($fp)
	lw $s4, -24($fp)
	lw $s3, -20($fp)
	lw $s2, -16($fp)
	lw $s1, -12($fp)
	lw $s0, -8($fp)
	lw $fp, -4($fp)
	addu $sp, $sp, 32 # realoc spatiul folosit de pe sitva
	jr $ra # si sar la adresa de la care a fost apelata procedura
