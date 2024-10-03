.data
    valores: .space 40          # Array de dados com espaço para 10 inteiros (4 bytes cada)
    tamanhoArray: .word 10      # Tamanho inicial do array

    # Mensagens para entrada e saída
    prompt: .asciiz "Insira 10 números inteiros:\n"
    sorted_msg: .asciiz "\nValores ordenados:\n"

.text
.globl main

main:
    # Imprimir prompt para entrada
    li $v0, 4
    la $a0, prompt
    syscall

    # Ler valores do usuário
    li $t0, 0        # $t0 = contador
    la $t1, valores  # $t1 = endereço inicial do array

read_loop:
    li $v0, 5         # syscall para ler inteiro
    syscall
    sw $v0, 0($t1)    # armazenar valor lido na posição atual do array
    addi $t0, $t0, 1  # incrementar contador
    addi $t1, $t1, 4  # avançar para a próxima posição do array
    bne $t0, 10, read_loop  # repetir se não tivermos lido 10 valores

    # Chamando a função de ordenação
    li $a0, 10         # tamanho do array
    la $a1, valores    # endereço do primeiro elemento do array
    jal bubble_sort

    # Imprimir valores ordenados
    li $v0, 4
    la $a0, sorted_msg
    syscall

    li $t0, 0         # reiniciar contador
    la $t1, valores   # reiniciar endereço do array

print_loop:
    lw $a0, 0($t1)    # carregar valor atual do array
    li $v0, 1         # syscall para imprimir inteiro
    syscall
    li $v0, 11        # syscall para imprimir espaço
    li $a0, ' '
    syscall

    addi $t0, $t0, 1  # incrementar contador
    addi $t1, $t1, 4  # avançar para o próximo valor do array
    bne $t0, 10, print_loop  # repetir se não tivermos imprimido 10 valores

    # Finalizar programa
    li $v0, 10
    syscall

bubble_sort:
    addi $sp, $sp, -40      # ajustar a pilha para guardar os 10 valores que serão usados

    # Guardando os registradores na pilha
    sw $ra, 36($sp)
    sw $a0, 32($sp)
    sw $a1, 28($sp)
    sw $t0, 24($sp)
    sw $t1, 20($sp)
    sw $t2, 16($sp)
    sw $t3, 12($sp)
    sw $t4, 8($sp)
    sw $t5, 4($sp)
    sw $t6, 0($sp)

    li $t0, 1  # troca = 1

while_loop:
    bne $t0, 1, end_while   # se $t0 diferente de 1, então saia do loop
    li $t0, 0               # troca = 0
    li $t1, 0               # i = 0

for_loop:
    mul $t2, $t1, 4         # calculando o valor do offset para pegar valores[i]
    add $t2, $t2, $a1       # adicionando o offset para encontrar o endereço de valores[i]
    lw $t3, 0($t2)          # aux = valores[i]

    addi $t4, $t1, 1        # $t4 = i + 1
    mul $t4, $t4, 4         # calculando o valor do offset para pegar valores[i+1]
    add $t4, $t4, $a1       # adicionando o offset para encontrar o endereço de valores[i+1]
    lw $t5, 0($t4)          # $t5 = valores[i+1]

    slt $t6, $t5, $t3       # se valores[i+1] < valores[i], $t6 = 1
    beq $t6, $zero, end_for # se valores[i+1] >= valores[i], vai para o final

    # Realizar troca
    li $t0, 1               # troca = 1
    sw $t5, 0($t2)          # valores[i] = valores[i+1]
    sw $t3, 0($t4)          # valores[i+1] = aux

end_for:
    addi $t1, $t1, 1        # i++
    li $t6, 9               # $t6 = tamanhoArray - 1
    slt $t6, $t1, $t6       # se i < (tamanhoArray - 1), $t6 = 1
    bne $t6, $zero, for_loop # repetir loop se $t6 for 1

    j while_loop

end_while:
    # Restaurando os registradores da pilha
    lw $t6, 0($sp)
    lw $t5, 4($sp)
    lw $t4, 8($sp)
    lw $t3, 12($sp)
    lw $t2, 16($sp)
    lw $t1, 20($sp)
    lw $t0, 24($sp)
    lw $a1, 28($sp)
    lw $a0, 32($sp)
    lw $ra, 36($sp)
    addi $sp, $sp, 40       # restaurar ponteiro da pilha

    jr $ra                  # voltar para o ponto que chamou a função
