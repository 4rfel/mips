lui $t0, 65535($zero)
begin:
addi $zero, 0($ra)
addi $t0, 10($zero)
addi $t1, 20($zero)
add $t1, $t0, $t1 # teste1 - resultado: 30
addi $t1, 0($t1) # t1 = 30
;add $t1, $t0, $t1 # teste1 - resultado: 30
ori $t1, 3($t1) # t1 = 31
ori $t1, 129($t1) # t1 = 31+128 = 159
andi $t1, 2($t1) # t1 = 2

# slti $t3, 2($t1) # t3 = t1 < 2 = 0
# slti $t3, 0($t1) # t3 = t1 < 0 = 0

addi $t8, 70($zero)
slti $t3, 4($t1) # t3 = t1 < 3
bne $t3, $zero, 1 # t3 != 0 PC + 4 + 4
j begin

addi $t8, 66($zero)
addi $t8, 67($zero)
addi $t8, 68($zero)
addi $t8, 69($zero)


addi $t7, 1($zero)
sw $t7, 0($zero)
lw $v1, 0($zero)
add $t0, $v1, $v1 # gera 2
add $t1, $t0, $v1 # gera 3
add $t2, $t1, $t1 # gera 6
sw $v1, 0($zero) # (0) = 0
sw $t0, 4($zero) # (1) = 2
sw $t1, 8($zero) # (2) = 3
sw $t2, 16($zero) # (4) = 6

lw $t0, 16($zero) # 6
lw $t1, 8($zero) # 3
lw $t2, 4($zero) # 2
lw $t3, 0($zero) # 1

addi $t6, 1($zero) # 1
add $t6, $t6, $t3 # 2
add $t6, $t6, $t2 # 4
add $t6, $t6, $t1 # 7
add $t6, $t6, $t0 # 13

lui $t6, 43690($zero)

addi $t8, 8($zero)

jr $t8
# jal begin

# beq $zero, $zero, begin
