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
	LINES: 	.word 0:10 # an array of 10 integers(words), each is initialized to be 0
	
	rd: 	.word 99:10
	
	
	hex: 		.byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
				
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
	####################################################################
	addi 	$t0, $0, 1
	addi	$t1, $0, 1
	main_loop:
		la	$4, NEWLINE
		jal	print_string
		
		la	$4, INSN_HEAD
		jal	print_string
		
		print_int($t0)
		beq 	$t0, $t1, one
	one:
		la	$4, SRCREGS
		jal 	print_string
		la	$4, MSG_NONE
		jal	print_string
		
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
	sll	$v0, $v0, 4
	add	$v0, $v0, $t4	
	addi	$t0, $t0, 1		#i++
	bne	$t0, $t1, a1
	addi	$a0, $v0, 0
	
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	addi 	$v0, $a0, 0
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
.globl get_src_regs
get_src_regs:
	addi	$sp, $sp, -4		#make the stack
	sw	$ra, 0($sp)		#store the return address
	jal	isn_helper		#calls the instruction code helper function
	addi	$t5, $v1, 0		#v1 is fro isn_helper which tells us what type of format the machine code is
	addi	$t3, $0, 1		#1 is r-format, 2 is i-format, 3 is j-format, 4 is src_error
	beq	$t5, $t3, rsource
	addi	$t3, $0, 2
	beq	$t5, $t3, isource
	addi 	$t3, $0, 4
	beq	$t5, $t3, src_error
rsource:
					#t2 will be first source
					#t3 will be second source
	sll	$t2, $s0, 6		#shift left the machine code 6 times and shift right 27 times for source 1
	sll 	$t3, $s0, 11		#shift left the machine code 11 times and shift right 27 times for source 2
	srl	$t2, $t2, 27	
	srl	$t3, $t3, 27
	addi	$a0, $t2, 0		#set a0 to be the first source
	addi	$v1, $t3, 0		#set v1 to be the second source
	j src_exit
isource:
	addi	$t6, $0, 5		#checks if the instruction code is bne, if so it follows the steps of the r-format
	beq 	$t6, $v0, rsource	#jumps to rsource extraction
	sll	$t2, $s0, 6		#shift left 6 times and shift right 27 times for the source register of a regular i format instruction
	srl	$t2, $t2, 27
	addi	$a0, $t2, 0
	addi	$v1, $zero, 32		#set v1 to be 32 to show that it is not used
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
isn_helper:
	addi	$sp, $sp, -4		#store caller address
	sw	$ra, 0($sp)
								
	srl	$t0, $s0, 26		#s0 = argument, t0 = opcode
	addi	$t1, $0, 0x3F
	and	$t0, $t0, $t1		#t0 == OPCODE
	
	
	beq	$t0, $0, rformat	#if t0 == 0 then rformat
	addi	$t1, $0, 2
	beq	$t0, $t1, funct_j	#if t0 == 2 then jump
	addi	$t1, $t1, 1
	beq	$t0, $t1, funct_jal	#if t0 = 3 then jump and link
	
iformat:
	addi	$t5, $0, 2		#t5 = iformat
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
	addi	$t5, $0, 4		#t5 = error format
	addi 	$a0, $zero, 0xFFFFFFFF	
	j	isn_exit
funct_j:
	addi 	$t5, $0, 3		#t5 = j format
	addi	$a0, $zero, 6
	j	isn_exit
funct_jal:
	addi 	$t5, $0, 3		#t5 = j format
	addi	$a0, $zero, 7
	j	isn_exit
rformat:
	addi 	$t5, $0, 1		#t5 = r format
	addi	$t0, $s0, 0		
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
	lw	$ra, 0($sp)		#restore caller address
	addi	$sp, $sp, 4
	addi	$v0, $a0, 0 		#instruction code output
	addi	$v1, $t5, 0		#format	code
	jr 	$ra
