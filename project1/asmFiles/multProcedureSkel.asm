	org		0x0000

	ori		$sp, $zero, 0x4000

	ori		$t3, $zero, 15
	ori		$t4, $zero, 8
	ori		$t5, $zero, 3
	ori		$t6, $zero, 17
	ori		$t7, $zero, 6

#	< push $3 >
	push $t3
#	< push $4 >
	push $t4
#	< push $5 >
	push $t5
#	< push $6 >
	push $t6
#	< push $7 >
	push $t7	
	jal mult
	jal mult
	jal mult
	jal mult



#	< jump to mult >
#	< jump to mult >
#	< jump to mult >
#	< jump to mult >
#	15 * 8 * 3 * 17 * 6  should be at 0x3FFC
	halt




	org 0x0800
mult:
	lw $t1,0($sp)
	
	addiu $sp,$sp,4
	lw $t2,0($sp)
	addiu $sp,$sp,4
	ori $t7, $zero, 0x0004
	ori $t8, $zero, 0x0001
	ori $t3, $zero, 0x0001
	ori $t4, $zero, 0x0100

	ori $t6,$zero,0x0000

loop:   beq $t4,$zero,exit
	
	#if temp = B then product += A
	and $t5,$t2,$t3

	bne $t5,$t3,noteq
	addu $t6,$t6,$t1

noteq:

	sll $t1,$t1,1
	sll $t3,$t3,1
	
	subu $t4,$t4,$t8
	j loop
exit:
	
	#push $6

	
	subu $sp,$sp,$t7
	sw $t6,0($sp)
	jr $31

