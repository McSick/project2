org 0x0000
ori $15, $zero, 0x80
ori $2, $zero, 0xF0
lw $1, 0($15)
addu $3,$1,$2
sw $3, 4($15)
halt