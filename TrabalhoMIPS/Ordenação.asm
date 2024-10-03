.data
	valores: .word 0:10     
	tamanhoArray: .word 10  
	
	
	prompt: .asciiz 
	sorted_msg: .asciiz "
	
.text
.globl main

main:
	li $v0, 4
	la $a0, prompt
	syscall
	
	li $t0, 0        
	la $t1, valores 
	
	read_loop:
	li $v0, 5         
	syscall
	sw $v0, 0($t1)   
	addi $t0, $t0, 1
	addi $t1, $t1, 4 
	bne $t0, 10, read_loop
	
	li $a0, 10         
	la $a1, valores   
	jal bubble_sort
	
	li $v0, 4
	la $a0, sorted_msg
	syscall
	
	li $t0, 0        
	la $t1, valores   
	
	print_loop:
	lw $a0, 0($t1)    
	li $v0, 1        
	syscall
	li $v0, 11        
	li $a0, ' '
	syscall
	
	addi $t0, $t0, 1  
	addi $t1, $t1, 4 
	bne $t0, 10, print_loop  
	
	li $v0, 10
	syscall

bubble_sort:
	addi $sp, $sp, -40     
	
	
	
	
	lw $ra, 36($sp)
	lw $a0, 32($sp)
	lw $a1, 28($sp)
	lw $t0, 24($sp)
	lw $t1, 20($sp)
	lw $t2, 16($sp)
	lw $t3, 12($sp)
	lw $t4, 8($sp)
	lw $t5, 4($sp)
	lw $t6, 0($sp)
	addi $sp, $sp, 40      
	
	jr $ra
	
end:
	li $v0, 10
	syscall
