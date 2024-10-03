.data

	numero: .asciiz "Digite um numero inteiro: "
	
.text
	li $v0, 4
	la $a0, numero
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	li $t1, 1
	li $s0, 1
	
	while:
		bgt $t1, $t0, sair
		mul $s0, $t1, $s0
		addi $t1, $t1, 1
		j while
	
	sair:
	
		li $v0, 1
		move $a0, $s0
		syscall
