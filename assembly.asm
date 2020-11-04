begin:
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

addi $t8, 69($zero)
slti $t3, 3($t1) # t3 = t1 < 3
bne $t3, $zero, 2 # t3 != 0 PC + 4 + 2
j begin


; 11110
; 00100
; 11110
