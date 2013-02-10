	org		0x0000
	ori		$15, $zero, 0x3FF8 # two spots lower
	ori             $29, $zero, 0x3FF8
	
mult:	


	pop $t1
	pop $t2
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
	#     < insert your code here >
	#     < notice that the stack has already been setup >
exit:
	
	#push $6
	or $24, $zero,$t6
	push $t6


	
	halt 


	org		0x3FF8
	cfw		5
	cfw		10 

