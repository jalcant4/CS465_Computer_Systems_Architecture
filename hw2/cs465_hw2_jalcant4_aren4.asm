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
	char0: .byte '0'
	str1: .asciiz "Hello World"
	


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
main:
	la	$a0, str1	#test strlen
	jal	atoi
	add	$a0, $v0, $0
	li	$v0, 1
	syscall
	
exit:	
	li $v0, 10		#exit
    	syscall

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
.globl atoi
atoi:
					#the following code
					#	t0 = strlen
					#	a0 = char *string 
	addi 	$sp, $sp, -4		#store ra
	sw	$ra, 0($sp)
	
	addi	$sp, $sp, -4		#find strlen
	sw	$a0, 0($sp)
	jal	strlen
	
	addi 	$t0, $v0, 0		#store strlen
	lw	$a0, 4($sp)		#reload a0
	addi	$sp, $sp, 4
	addi	$t1, $t1, 0
	addi	$t4, $t4, 1		
a1:
					#the following code
					#	t1 = counter
					#	t2 = (a + i)
					#	t3 = *(t1)
					#	t4 = NaN flag
					#		if 0, then NaN
					#		if 1, then Number
					#	t5 = 9, t3 (use for arithmatic operation)
	add	$t2, $a0, $t0
	lb	$t3, 0($t2)
	
	addi	$t5, $t5, 9		#test 0 <= t2 <= 9
	sle	$t4, $0, $t3		 
	sle	$t4, $t3, $t9
	beq	$t4, $0, a2		#if NaN a2
	
	addi	$t5, $t3, $0		#t5 = t3
					#v0 = v0 + t3
					#v0 *= 10 == v0 << 4 - v0 << 3 + v0 << 2
					#if iterating, jmp a1
					#if at last index, jmp a3
a2:
	addi	$v0, $0, $0
a3:
	lw	$ra, 4($sp)
	addi	$sp, $sp, 4
	jr $ra
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

	jr $ra



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
	lb	$a1, 0($a0)		#load the first element		
	#
	sne	$t0, $a1, $0		#test if $a1 != '\0', t0 = 1
	bne	$t0, $0, S1
	add	$v0, $zero, $zero	#if v0 == 0 ret 0
	#
	addi	$sp, $sp, 4		#Pop local data off stack
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
        
