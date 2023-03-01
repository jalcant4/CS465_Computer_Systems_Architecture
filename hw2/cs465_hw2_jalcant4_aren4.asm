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
	hex: 	.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	input: 	.space 9 # 8 characters + 1 null byte

#############################################################
# Code segment
#Caller - Callee explained
#callee must save callee registers: s0-s7, sp, fp
#caller must save caller registers: ~callee regesters
#main is always the caller
#main calls func a, func a is the callee
#func a calls func b, func a is the caller and func b is the callee
#in this heirachy, main is the caller, and both a and b are callees
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
	addi	$s0, $v0, 0
	sw 	$a0, 0($sp)
	addi 	$a0, $0, 1
	jal 	step
	
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	addi 	$v0, $s0, 0
	jr 	$ra
#############################################################
# get_insn_code
#############################################################
#############################################################
# DESCRIPTION OF ALGORITHM 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

.globl get_insn_code
get_insn_code:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	
	#field size	6b	5b	5b	5b	5b	6b
	#r format	op	rs	rt	rd	shamt	funct
	#i format	op	rs	rt	address/immediate ->
	#j format	op	target address 	->	->	->
	
				
	srl	$t0, $s0, 26		#t0 = opcode
	addi	$t1, $0, 0x3F
	and	$t0, $t0, $t1
	
	beq	$t0, $0, rformat
	addi	$t1, $0, 2
	beq	$t0, $t1, funct_j
	addi	$t1, $t1, 1
	beq	$t0, $t1, funct_jal
iformat:
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
	addi 	$a0, $zero, 0xFFFFFFFF	
	j	isn_exit
funct_j:
	addi	$a0, $zero, 6
	j	isn_exit
funct_jal:
	addi	$a0, $zero, 7
	j	isn_exit
rformat:
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
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

.globl get_src_regs
get_src_regs:


	jr $ra


#############################################################
# get_next_pc
#############################################################
#############################################################
# DESCRIPTION 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################

.globl get_next_pc
get_next_pc:


	jr $ra




#############################################################
# optional: other helper functions
#############################################################
.globl strlen
#int strlen(char *s) {
#	if *s = '\0' ret 0
#	return 1 + strlen(*[s + 1])
#}
strlen:
	# high address	$fp 	
	# 			$ra
	# 			$ra
	# 			...
	# 			$ra
	# low address	$sp
	# 			...
	#store char s on stack
	addi	$sp, $sp, -4		#Make space for word. Each word is 4 bytes. A char is 1 byte.
	sw	$ra, 0($sp)		#Save the return address
	lb	$t1, 0($a0)		#load the first element		
	#
	sne 	$t0, $t1, $0		#test if $a\t1 != '\0', t0 = 1
	bne	$t0, $0, S1
	add	$v0, $zero, $zero	#if v0 == 0 ret 0
	#
	jr 	$ra	
S1:
	la 	$a0, 1($a0)		#array = array[i - 1: end]
	jal	strlen
	#
	lw	$ra, 4($sp)		#restore address
	addi	$sp, $sp, 4		#pop 2 items from the stack
	#
	addi	$v0, $v0, 1		#increment
	jr	$ra			#return 

#int multiply(int a0, int a1) {
#	return a * b
#}
#assumptions	positive values only, undefined behavior if negative
#param 	a0	the multiplicand
#param 	a1	the multiplier	
#ret 	v0	the product of a0 and a1									
.globl multiply
multiply:
	addi 	$sp, $sp, -4
	sw	$ra, 0($sp)
m1:
	add 	$t0, $a1, $0		#mov a1 t0
	and	$t0, $t0, 1		#a1 & 0x0001
	beqz	$t0, m2			#test multiplier
	add	$v0, $v0, $a0
m2:
	srl	$a1, $a1, 1		#shift multiplier right
	bnez	$a1, m1	
	lw	$ra, 4($sp)
	addi	$sp, $sp, 4
        jr 	$ra

