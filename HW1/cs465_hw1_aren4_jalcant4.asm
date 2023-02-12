#############################################################
# NOTE: this is the provided TEMPLATE as your required 
#	starting point of HW1 MIPS programming part.
#
# CS465 S2023 HW1  
#############################################################
#############################################################
# PUT YOUR TEAM INFO HERE
# Allen Ren
# G# 01135138
# jed alcantara
# G# 00846927
#############################################################

#############################################################
# DESCRIPTION OF ALGORITHMS 
#
# PUT A BRIEF ALGORITHM DESCRIPTION HERE
# 1. hexdecimal string to integer value
# 2. extract bits between high and low indexes (inclusively)
#############################################################

#############################################################
# Data segment
# 
# Use the provided string for exact match;
# Feel free to add more data items
#############################################################
.data
	INPUTMSG: 	.asciiz "Enter a hexadecimal number: "
	INPUTHIGHMSG: 	.asciiz "Specify the high bit index to extract (0-LSB, 31-MSB): "
	INPUTLOWMSG: 	.asciiz "Specify the low bit index to extract (0-LSB, 31-MSB, low<=high): "
	OUTPUTMSG: 	.asciiz "Input: "
	BITSMSG: 	.asciiz "Extracted bits: "
	ERROR: 		.asciiz "Error: Input has invalid digits!"
	INDEXERROR: 	.asciiz "Error: Input has incorrect index(es)!"
	EQUALS: 	.asciiz " = "
	NEWLINE: 	.asciiz "\n"
	ZERO: 		.asciiz "0"
	TEN: 		.asciiz "A"
	VALID: 		.word '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	VALID_LEN: 	.word 16
	INPUT_LEN:	.word 8
	SUM:		.word 0 
	.align 4
	INPUT: .space 9 # 8 characters + 1 null byte

#############################################################
# Code segment
#############################################################
.text

#############################################################
# Provided entry of program execution
# DO NOT MODIFY this part
#############################################################
		
main:
	li $v0, 4
	la $a0, INPUTMSG
	syscall	# print out MSG asking for a hexadecimal
	
	li $v0, 8
	la $a0, INPUT
	li $a1, 9 # 8 characters + 1 null byte
	syscall # read in one string of 8 chars and store in INPUT

#############################################################
# END of provided code that you CANNOT modify 
#############################################################
				
# sample code of checking INPUT buffer

# 	la $a0, INPUT	#load address of INPUT
# 	li $v0, 4		#print contents of INPUT as string 
# 	syscall
# 	li $v0, 4
# 	la $a0, NEWLINE
# 	syscall			#example printing: a newline
# 
# 	la $a0, INPUT	#load address of INPUT
# 	li $v0, 34		#print address of INPUT as hex number 
# 	syscall
# 	li $v0, 4
# 	la $a0, NEWLINE
# 	syscall			
# 
# 	lb $a0, INPUT	#load one byte from INPUT
# 	li $v0, 34		#print the byte as hex number 
# 	syscall
# 	li $v0, 4
# 	la $a0, NEWLINE
# 	syscall	
# 
# 	lb $a0, INPUT	#load one byte from INPUT
# 	li $v0, 11		#print the byte as character
# 	syscall
# 	li $v0, 4
# 	la $a0, NEWLINE
# 	syscall	

		
##############################################################
# Add your code here to extract the numeric value from INPUT 
##############################################################
	la $t0, INPUT
	add $t1, $t1, $zero		#atoi ctr
	add $s0, $zero, $zero   	#sum
atoi:
 	lb $a0, ($t0)			#char = *(INPUT) = a0	
	#for int i = 0; i < VALID.length; i++
	#	if char == VALID[i]
	#		jump to mult16
	#end_loop
init_loop:
	add $t2, $t2, $zero		#t2 = i (loop ctr)
	la $s1, VALID			#s1 = VALID
	lw $t3, VALID_LEN		#load length in t3
	addi $t3, $t3, -1		#VALID_LEN = VALID_LEN - 1
	lw $t4, INPUT_LEN		#load the length of INPUT
loop:
	bgt  $t2, $t3, print_error	#end the loop i(t2) >= VALID_LEN(t3)
	sll $t5, $t2, 2			#i * 4
	add $t5, $t5, $s1		#addr of s1[t2]
	lb $a1, 0($t5)			#a1 = VALID[i]
	beq $a0, $a1, sum		#if char == VALID[i] sum
	addi $t2, $t2, 1		#i++
	j loop
sum:
	add $s0, $s0, $t2		#sum + i
inc_loop:
	addi $t0, $t0, 1 		#increments every loop in order to go through every part of the array
	addi $t1, $t1, 1		#increment i from 0 to 8
	beq $t1, $t4, report_value		#if at s1[7]
	sll  $s0, $s0, 4		#sum *= 16
	ble $t1, $t4, atoi 		#branch to jump back to atoi			
print_error:
	li $v0, 4
	la $a0, ERROR
	syscall
	j exit
report_value:
#############################################################
# Add your code here to print the numeric value
# Hint: syscall 34: print integer as hexadecimal
#	syscall 36: print integer as unsigned
#############################################################
 	li $v0, 4
	la $a0, NEWLINE
 	syscall	
 	li $v0, 4
	la $a0, OUTPUTMSG
	syscall	
 	la $a0, ($s0)
	li $v0, 34
	syscall
	li $v0, 4
	la $a0, EQUALS
	syscall
	li $v0, 36
	la $a0, ($s0)
	syscall
 	li $v0, 4
	la $a0, NEWLINE
 	syscall	



#############################################################
# Add your code here to get two integers: high and low
#############################################################

	li $v0, 4
	la $a0, INPUTHIGHMSG
	syscall	# print out MSG asking for high index

		
#############################################################
# Add your code here to extract bits and print extracted value
#############################################################

#############################################################
# Exit to terminate the execution
#############################################################
exit:
	li $v0, 10
	syscall

# Example input	
# Hex:	  0x 0   1    2    3    4    5    6    B
# Binary: 0000 0001 0010 0011 0100 0101 0110 1011
#    	  31   27   23   19   15   11   7    3  0 (index)
