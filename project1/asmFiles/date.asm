org		0x0000


ori		$sp, $zero, 0x4000
ori		$23, $zero, 2012 #year
ori		$24, $zero, 12 #Month
ori		$25, $zero, 14 #day
ori 		$26, $zero, 30 
ori 		$27, $zero, 2000
ori 		$21, $zero, 365
ori 		$9, $zero, 1



subu $24,$24,$9 #month -1
subu $20,$23,$27 #year -2000

push $26
push $24
jal mult
pop $24 #second term

push $21
push $20

jal mult
pop $23

addu $24,$24,$25

addu $24,$24,$23

push $24

halt

mult: 
	lw $1,0($sp)
	
	addiu $sp,$sp,4
	lw $2,0($sp)
	addiu $sp,$sp,4
	ori $7, $zero, 0x0004
	ori $8, $zero, 0x0001
	ori $3, $zero, 0x0001
	ori $4, $zero, 0x0100

	ori $6,$zero,0x0000

loop:   beq $4,$zero,exit
	
	#if temp = B then product += A
	and $5,$2,$3

	bne $5,$3,noteq
	addu $6,$6,$1

noteq:

	sll $1,$1,1
	sll $3,$3,1
	
	subu $4,$4,$8
	j loop
exit:
	
	#push $6

	
	subu $sp,$sp,$7
	sw $6,0($sp)
	jr $31
