############################################################
# NOTE: this is the provided template file  
#       of HW3 MIPS programming part.
#
# CS465-001 S2023
# HW3  
#############################################################

#############################################################
# PUT YOUR TEAM INFO HERE
# NAME
# G#
# NAME Jed Alcantara
# G# 00846927
#############################################################

#############################################################
# For this assignment, you will write a program to accept a sequence of machine code (as hexadecimal strings) from the user, 
# decode, identify and report true data dependences as well as stalls triggered by data hazards 
# for a 5-stage pipeline processor with no forwarding.
#############################################################


#############################################################
# Data segment
#############################################################

.data

	PROMPT_N: .asciiz "How many instructions to process (valid range: [1,10])? "
	PROMPT_SEQUENCE: .asciiz "Please input instruction sequence (one per line):"
	PROMPT_NEXT: .asciiz "\nNext instruction: 0x"
	ERROR_N: .asciiz "Incorrect number of instructions\n"

	INSN_HEAD: .asciiz "I"
	SRCREGS: .asciiz "\nDependence Info: "
	MSG_NONE: .asciiz "None"	
	MSG_DIVIDER: .asciiz "\n-------------------------------------------\n"

	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"

	.align 2
	INPUT: .space 9
	
	.align 2
	LINES: 			.word 0:10 # an array of 10 integers(words), each is initialized to be 0
	
	DEST:	.word 99:10
	hex: 			.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
				
# Feel free to define more data elements

#############################################################
# Code segment
#############################################################

.text

#############################################################
# macro example: print_int
#############################################################
# %x: value to be printed	
# example usage: print_int($t0)
# NOTE: $v0 and $a0 will be updated if you use this macro

.macro print_int (%x)
	li $v0, 1
	add $a0, $zero, %x
	syscall
	.end_macro




#############################################################
# main
#############################################################

main:

	# print out message asking for N (number of instructions to process)
	####################################################################
	la $a0, PROMPT_N
	jal print_string 
	
	# read in an integer N
	####################################################################
	li $v0, 5
	syscall 
	addi $s0, $v0, 0  #keep N in $s0
	
	# verify input N 
	####################################################################
	ble $s0, $0, error_report #if N<=0, error
	bgt $s0, 10, error_report #if N>10, error 
	
	# print out prompt to ask for a sequence
	####################################################################
	la $a0, PROMPT_SEQUENCE	
	jal print_string 
	
	# initialization to prepare for the loop
	####################################################################
	li $s2, 0 # loop index i=0
	la $s1, LINES #stating addr of array of instructions

	# loop of reading in N strings
	# 	for i in range of N
	#		LINES[i] = INPUT
	####################################################################
	Loop: 
		# Print out prompt for next instruction
		####################################################################
		la $a0, PROMPT_NEXT 
		jal print_string												

		# read in one string and store in INPUT
		####################################################################
		la $a0, INPUT
		li $a1, 9
		li $v0, 8
		syscall 

		# call atoi() to extract the numeric value from INPUT
		####################################################################
		la $a0, INPUT
		jal atoi

		#save the return of atoi() in array LINES[i]
		####################################################################
		sw $v0, 0($s1)		

		# update and check loop condition
		####################################################################
		addi $s1, $s1, 4 # offset of next array item																																
		addi $s2, $s2, 1 # i++
		blt $s2, $s0, Loop # i<N==>loop back
		
	####################################################################
	# end of loop of reading in N strings
	####################################################################

	####################################################################
	# TODO: add your code here to process the instruction sequence,
	#       report true data dependences and stalls
	###########################################################f#########
	la	$s1, LINES
	la	$s3, DEST
	addi 	$s2, $0, 1			#instruction cycle counter
	addi	$s4, $0, 1			#instruction sequence number
	main_loop:
		la	$4, NEWLINE		#print newline
		jal	print_string
		
		la	$4, INSN_HEAD		#print instruction head
		jal	print_string
		
		print_int($s0)			#print instruction head such that I1, I2, ... IN
		
		
		addi	$t3, $s4, -1		# isn - 1
		sll	$t3, $t3, 2
		add	$a0, $s1, $t3		# add the isn to the base address to get a0 = LINES[isn - 1], machine code
		lw 	$a0, 0($a0)		# extracts the machine code from the array
		jal 	get_regs
		jal	compare
		# update DEST
		sw	$a2, 0($s3)		# saves the destination register into the dest array
		addi	$s3, $s3, 4		# offset of next array item
		addi	$s4, $s4, 1		# update values
		beq	$s4, $s0, exit		# if t1 == N, exit
		
	# for i in range of N:
	# 	t0 = LINES[i + 0]
	#	if i + 1 <= N
	#		compare_regs
	#	if i + 2 <= N
	#	if i + 3 <= N
	
	
	
###########################################
#  exit 
###########################################
exit:
	li $v0, 10
	syscall

error_report:
	la $a0, ERROR_N
	li $v0, 4
	syscall # Print out error message for incorrect N 
	j exit

######## end of main ###################
########################################	


	
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
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
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
	sll	$v0, $v0, 4		# multiply the cumulative bits by 16
	add	$v0, $v0, $t4		# add the most recent bits to v0
	addi	$t0, $t0, 1		# i++
	bne	$t0, $t1, a1		# if i != 8 loop back to a1
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr 	$ra

#############################################################
# optional: other helper functions
#############################################################
				


#############################################################
# subroutine: print_string
#############################################################
# to use: set $a0 as the address of string to be printed
print_string:
	li $v0, 4
	syscall	
	jr $ra


#############################################################
# subroutine: print_dependence
#############################################################
# to use:
#   - set $a0 as the reg number; 
#   - set $a1 as the index of producer instruction

.data
	COMMA: 	.asciiz ", "
	SRC_REG_HEAD: .asciiz "\n\tSource Register: "
	PRODUCER: .asciiz "Producer Instruction: I"
	

.text:
print_dependence:
	
	addi $sp, $sp, -12	#save arguments and $ra
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
		
	la $a0, SRC_REG_HEAD	#print start
	jal print_string
	
	lw $a0, 4($sp)	#print reg num
	print_int($a0)
	
	la $a0, COMMA	#print comma
	jal print_string
	
	la $a0, PRODUCER	#print more msg
	jal print_string
	
	lw $a0, 0($sp)	#print producer
	print_int($a0)
		

	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra


#############################################################
# subroutine: print_cycle
#############################################################
# to use: set $a0 as the assigned cycle (int value)
 
.data
	CYCLE_HEAD: .asciiz "\nStart Cycle: "
	

.text:
print_cycle:
	addi $sp, $sp, -8	#save argument and $ra
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	la $a0, CYCLE_HEAD	#print start
	jal print_string

	lw $a0, 0($sp)		#print cycle
	print_int($a0)
	

	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

####### Helper Method Section ######
#######
# Gets the register associated with the instruction
#######

.globl compare
compare:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	addi	$t0, $s4, -1			# i = size(dst) - 1
compare_loop:					#for each element in DST
	la	$t1, DST
	sll	$t2, $t0, 2
	addi	$t1, $t1, $t2			# t1 = &(DST[i])

	lw 	$t2, 0($t1)			# t2 = DST[i]
	
						# exit condtions
	beq	$a0, $t2, comp_oper		# if DST[i] == a0
	beq	$a1, $t2, comp_oper2		# if DST[i] == a1
	beq	$t0, $s4, exit_comp_loop	# if DST does not contain, or is empty
	
	addi	$t0, $t0, 1			# i++
	j	compare_loop
comp_oper:
	add	$v0, $zero, $a0
	beq	$a1, $t2, comp_oper		# if DST[i] == a1
comp_oper2:
exit_comp_loop:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
##########
#returns:
#	two_src_regs: 
#		dst = a2 
#		src = a0, a1
#	one_src_regs:
#		dst = a2
#		a1 = 32
#		src = a0
#
##########	
.globl get_regs
get_regs:
	addi	$sp, $sp, -4		#make the stack
	sw	$ra, 0($sp)		#store the return address
	jal	isn_helper		#calls the instruction code helper function
	
	addi	$t5, $v0, 0		#v0 is from isn_helper which tells us the instruction code
	addi	$t3, $0, 0		#if sub, then two source registesr
	beq	$t5, $t3, two_src_reg
	addi	$t5, $v0, 5		#if bne, then two source registers
	addi	$t3, $0, 5		
	beq	$t5, $t3, branch
	addi	$t5, $v0, 2		#if slt, then two source registers
	addi	$t3, $0, 2		
	beq	$t5, $t3, two_src_reg
	
one_src_reg:				#everything else, one source register
	sll	$t2, $a0, 6		#shift left 6 times and shift right 27 times for the source register of a regular i format instruction
	srl	$t2, $t2, 27
	sll	$t3, $a0, 11		#shift left 6 times and shift right 27 times for the destination register
	srl	$t3, $t3, 27	
	addi	$a0, $t2, 0		#set a0 to be the source register
	addi	$a1, $zero, 32		#set a1 to be 32 to show that it is not used
	addi	$a2, $t3, 0		#set a2 to be the destination register
	j src_exit
					#t2 will be first source
					#t3 will be second source
two_src_reg:
	sll	$t2, $a0, 6		#shift left the machine code 6 times and shift right 27 times for source 1
	sll 	$t3, $a0, 11		#shift left the machine code 11 times and shift right 27 times for source 2
	sll	$t4, $a0, 16		#shift left the machine code 16 times and shift right 27 times for destination regs
	
	srl	$t2, $t2, 27	
	srl	$t3, $t3, 27
	srl	$t4, $t4, 27
	
	addi	$a0, $t2, 0		#set a0 to be the first source
	addi	$a1, $t3, 0		#set a1 to be the second source
	addi	$a2, $t4, 0		#set a2 to be the destination register
	j src_exit
branch: 
	sll	$t2, $a0, 6		#shift left the machine code 6 times and shift right 27 times for source 1
	sll 	$t3, $a0, 11		#shift left the machine code 11 times and shift right 27 times for source 2
	
	srl	$t2, $t2, 27	
	srl	$t3, $t3, 27
	
	addi	$a0, $t2, 0		#set a0 to be the first source
	addi	$a1, $t3, 0		#set a1 to be the second source
	addi	$a2, $zero, 32		#set a2 to be the destination register
	j src_exit
src_error:
	addi 	$a0, $zero, 0xFFFFFFFF	#sets a0 to be the invalid code
src_exit:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	addi	$v0, $a0, 0
	jr $ra
#######
# The instruction helper class parses the format of the instruction
#     and identifies the instruction by OPCODE
#######	
#v0 will report to us what the instruction code is
isn_helper:
	addi	$sp, $sp, -4		#store caller address
	sw	$ra, 0($sp)		#saves return address to go back to get_src_regs
								
	srl	$t0, $a0, 26		#a0 = argument, t0 = opcode
	addi	$t1, $0, 0x3F		#t1 gets used to isolate the OPCODE
	and	$t0, $t0, $t1		#t0 == OPCODE
	beq	$t0, $0, rformat	#if t0 == 0 then rformat
iformat:
	addi 	$t1, $0, 8
	addi	$v0, $zero, 1		#if it is addi, set v0 to 1
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 35
	addi	$v0, $zero, 3		#if it is lw, set v0 to 3
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 43
	addi	$v0, $zero, 4		#if it is sw, set v0 to 4
	beq	$t0, $t1, isn_exit
	addi 	$t1, $0, 5
	addi	$v0, $zero, 5		#if it is bne, set v0 to 5
	beq	$t0, $t1, isn_exit
error:
	addi 	$v0, $zero, 0xFFFFFFFF	#if it is an error, set v0 to 0xFFFFFFFF
	j	isn_exit
rformat:
	addi	$t0, $a0, 0		
	sll	$t0, $t0, 26
	beq	$t0, 0x22, funct_sub
	beq	$t0, 0x29, funct_slt
funct_sub:
	addi 	$v0, $zero, 0		#if it is sub, set v0 to 0
	j 	isn_exit
funct_slt:
	addi	$v0, $zero, 2		#if it is slt, set v0 to 2
	j 	isn_exit	
isn_exit:
	lw	$ra, 0($sp)		#restore caller address
	addi	$sp, $sp, 4
	jr 	$ra
