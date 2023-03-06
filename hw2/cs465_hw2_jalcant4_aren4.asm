#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#		starting point of HW2 MIPS programming part.
#		This is the only file you should change and submit.
#
# CS465-001 S2023
# HW2  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# NAME Jed Mendoza
# G#00846927
# NAME Allen Ren
# G# 2
#############################################################

#############################################################
# Data segment
#############################################################
.data
	hex: 		.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	input: 		.space 9 # 8 characters + 1 null byte
	insn_code:	.word
#############################################################
# Code segment
#Caller - Callee explained
#callee must save callee registers: s0-s7, sp, fp
#caller must save caller registers: not callee registers
#main is always the caller
#############################################################
.text

#############################################################
# atoi
#############################################################
#############################################################
#param the string representation of an integral number.
#assumptions
#	arg0 is stored in a0
#ret function returns the converted integral number as an int value.
#	if no valid conversion could be performed, it returns zero.
#############################################################
#Assumptions:
# The	string	buffer	has a string of	8 characters.	
# Only	capital case	letters	('A' to	'F')	and	decimal	digits	will	be	used	for	the	input.
# All	input	are	valid	hexadecimal	values -- no	need	to	check	and	report	invalid	digits
#	for	this	homework.
.globl atoi
atoi:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	
	addi	$v0, $0, 0
	addi	$t0, $0, 0		#i = 0
	addi	$t1, $0, 8		#input length = 8
a1:
	addi	$t2, $a0, 0		#t2 = a0			 
	add	$t2, $a0, $t0		#t2 = a0[i]
	
	lb	$t2, 0($t2)		#inp[i] 
	
	la	$t3, hex		#load array hex
	addi	$t4, $0, 0		#j = 0
	addi	$t5, $0, 16		#hex length = 16
a2:	
	add	$t6, $t3, $t4		#hex[j]
	lb	$t6, 0($t6)
	beq	$t2, $t6, a3		#if inp[i] == hex[j]
	addi	$t4, $t4, 1
	bne	$t4, $t5, a2
a3:	
	sll	$v0, $v0, 4
	add	$v0, $v0, $t4	
	addi	$t0, $t0, 1		#i++
	bne	$t0, $t1, a1
	addi	$a0, $v0, 0
	sw 	$a0, 0($sp)
	addi 	$a0, $0, 1
	jal 	step
	
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	addi 	$v0, $a0, 0
	jr 	$ra
#############################################################
# get_insn_code
#############################################################
#############################################################
# param	the value of the input
# ret	the function returns the instruction code of the input
#	0		sub
#	1		add
#	...
#	7		jal
#	0xFFFFFFFF	invalid
#############################################################

.globl get_insn_code
get_insn_code:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	#field size	6b	5b	5b	5b	5b	6b
	#r format	op	rs	rt	rd	shamt	funct
	#i format	op	rs	rt	address/immediate ->
	#j format	op	target address 	->	->	->	
	jal	isn_helper
	addi	$a0, $v0, 0
	sw	$a0, 0($sp)
	addi	$a0, $zero, 2
	jal 	step
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	addi	$v0, $a0, 0
	jr 	$ra
#############################################################
# get_src_regs
#############################################################
#############################################################
# DESCRIPTION OF ALGORITHM 
# param	the value of the input
# ret	if the input has a src register(s), return it
#	n/a if a jump command or invalid
#############################################################

.globl get_src_regs
get_src_regs:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	jal	isn_helper
	addi	$t5, $v1, 0
	addi	$t3, $0, 1
	beq	$t5, $t3, rsource
	addi	$t3, $0, 2
	beq	$t5, $t3, isource
	addi	$t3, $0, 3
	beq	$t5, $t3, jsource
	addi 	$t3, $0, 4
	beq	$t5, $t3, src_error
rsource:
					#t2 will be first source
					#t3 will be second source
	sll	$t2, $s0, 6
	sll 	$t3, $s0, 11
	srl	$t2, $t2, 27
	srl	$t3, $t3, 27
	addi	$a0, $t2, 0
	addi	$v1, $t3, 0
	sw	$a0, 0($sp)
	j src_exit
isource:
	addi	$t6, $0, 5
	beq 	$t6, $v0, rsource
	sll	$t2, $s0, 6
	srl	$t2, $t2, 27
	addi	$a0, $t2, 0
	addi	$v1, $zero, 32
	sw	$a0, 0($sp)
	j src_exit
jsource:
	addi	$v1, $zero, 0
	addi	$a0, $0, 32
	sw	$a0, 0($sp)
	j src_exit	
src_error:
	addi	$v1, $zero, 0
	addi 	$a0, $zero, 0xFFFFFFFF
	sw	$a0, 0($sp)
src_exit:
	addi	$a0, $zero, 3
	jal	step
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	addi	$v0, $a0, 0
	jr $ra
#############################################################
# get_next_pc
#############################################################
#############################################################
# DESCRIPTION 
# param	the value of the input
# ret	the address of the next step calculated from param
#############################################################
#sub,addi,slt,lw,sw 	pc + 4
#bne, 			pc + 4 + i * 4
#j, jal			  
.globl get_next_pc
get_next_pc:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	addi	$sp, $sp, -4
	sw	$a0, 0($sp)
	jal	isn_helper
	lw	$a0, 0($sp)
	addi	$sp, $sp, 4
	
	addi 	$t0, $0, 5
	beq	$v0, $t0, pc_bne
	addi	$t0, $0, 6
	beq	$v0, $t0, pc_j
	addi	$t0, $0, 7
	beq	$v0, $t0, pc_j
	addi	$t0, $0, 0xFFFFFFFF
	beq	$v0, $t0, error2
pc_4:
	addi	$a0, $a1, 4
	addi	$t0, $0, 0xFFFFFFFF
	j	pc_exit
error2:
	addi 	$a0, $zero, 0xFFFFFFFF	
	addi	$t0, $0, 0xFFFFFFFF
	j	pc_exit
pc_bne:
	sll	$t0, $a0, 16
	srl	$t0, $t0, 16
	addi	$a0, $a1, 4
	sll	$t0, $t0, 2 		#i * 4
	add	$t0, $a0, $t0		#t0 = (PC+4) + (i * 4)
	j	pc_exit
	
pc_j:
					#t0 = pc & 0xF0000000 + imm
					#	imm =  last 26 bits of a0 << 2
					#	https://chortle.ccsu.edu/assemblytutorial/Chapter-17/ass17_5.html
	addi	$t1, $a0, 0		#t0 = imm
	andi	$t1, $t1, 0x03FFFFFF	
	sll	$t1, $t1, 2		
	addi 	$t2, $a1, 0
	andi	$t2, $t2, 0xF0000000
	add	$t1, $t1, $t2
	addi	$a0, $t1, 0
	addi	$t0, $zero, 0xFFFFFFFF										
	j	pc_exit
pc_exit:
	addi 	$sp,$sp, -4
	sw	$a0, 0($sp)
	addi	$a0, $zero, 4
	jal 	step
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	addi	$v0, $a0, 0
	addi	$v1, $t0, 0
	jr 	$ra
#############################################################
# optional: other helper functions
#############################################################
#############################################################
#isn_helper
#############################################################
#extracts the instruction code and the format from a0 (a0 must be the input)
#param	a0	value of the input
#ret	v0	instruction code	(0-7, and 0xFFFFFFFF
#	v1	format of the code 	(r, i, j, invalid)
#############################################################              
isn_helper:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
								
	srl	$t0, $s0, 26		#t0 = opcode
	addi	$t1, $0, 0x3F
	and	$t0, $t0, $t1
	
	
	beq	$t0, $0, rformat	
	addi	$t1, $0, 2
	beq	$t0, $t1, funct_j
	addi	$t1, $t1, 1
	beq	$t0, $t1, funct_jal
iformat:
	addi	$t5, $0, 2
	addi 	$t1, $0, 8
	addi	$a0, $zero, 1
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 35
	addi	$a0, $zero, 3
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 43
	addi	$a0, $zero, 4
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 5
	addi	$a0, $zero, 5
	beq	$t0, $t1, isn_exit
error:
	addi	$t5, $0, 4
	addi 	$a0, $zero, 0xFFFFFFFF	
	j	isn_exit
funct_j:
	addi 	$t5, $0, 3
	addi	$a0, $zero, 6
	j	isn_exit
funct_jal:
	addi 	$t5, $0, 3
	addi	$a0, $zero, 7
	j	isn_exit
rformat:
	addi 	$t5, $0, 1
	addi	$t0, $s0, 0		#t0 = funct
	and	$t0, $t0, $t1
	beq	$t0, 0x22, funct_sub
	beq	$t0, 0x29, funct_slt
funct_sub:
	addi 	$a0, $zero, 0
	j 	isn_exit
funct_slt:
	addi	$a0, $zero, 2
	j 	isn_exit	

isn_exit:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	addi	$v0, $a0, 0 		#instruction code output
	addi	$v1, $t5, 0		#format	code
	jr 	$ra

