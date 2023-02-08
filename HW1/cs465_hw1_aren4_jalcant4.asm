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
	INPUTMSG: .asciiz "Enter a hexadecimal number: "
	INPUTHIGHMSG: .asciiz "Specify the high bit index to extract (0-LSB, 31-MSB): "
	INPUTLOWMSG: .asciiz "Specify the low bit index to extract (0-LSB, 31-MSB, low<=high): "
	OUTPUTMSG: .asciiz "Input: "
	BITSMSG: .asciiz "Extracted bits: "
	ERROR: .asciiz "Error: Input has invalid digits!"
	INDEXERROR: .asciiz "Error: Input has incorrect index(es)!"
	EQUALS: .asciiz " = "
	NEWLINE: .asciiz "\n"
	ZERO: .asciiz "0"
	TEN: .asciiz "A"
	VALID: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','NUL'
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
	la $t4, INPUT
	#add $t0, $t0, 1		#increment value
	add $t1, $t1, 0		#loop var
	add $t2, $t2, 7		#loop ceiling
	add $t3, $t3, 16	#mult val
	#add $t6, $t6, 57	#ascii values {48-57}
	#add $t7, $t7, 70	#ascii values {65-70}
	add $s0, $zero, $zero   #final integer
atoi:
 	li $v0, 4 		#prints new line from line 113-115
	la $a0, NEWLINE
 	syscall	
 	lb $a0, ($t4)		#load one byte from INPUT
 	
	#la $t6, RANGE_INT	#load the lower and upper bounds of the range int
	#ble $a0, $t6, int	#if value is less than or equal to 57, jump to int
	#ble $a0, $t7, char	#if value is less than or equal to 70, jump to char
	
	#for int i = 0; i < VALID.length; i++
	#	if a0 == VALID[i]
	#		jump to mult16
	#if the byte does not match the list, error
	add $t6, $t6, $zero
	add $t7, $t7, 16
loop:
	
	addi $t6, $t6, 1
	beq $t6, $t7, print_error	#iterated through loop and did not find a valid hex
	j loop
print_error:
	li $v0, 4
	la $a0, ERROR
	syscall
	j exit
int:
	addi $t5, $a0, -48	#t5 - 48 = {0-9}
 	add $a0, $zero, $t5	#
	blt $t1, $t2 mult16	#jump to atoi2
	add $s0, $s0, $a0
	j atoi2
char:
	addi $t5, $a0, -55
 	add $a0, $zero, $t5
	blt $t1, $t2 mult16	#jump to atoi2
	add $s0, $s0, $a0
	j atoi2
mult16:
	add $s0, $s0, $a0	#add the value to a1
	mult $s0, $t3		#multiply the value by 16
	j atoi2 
atoi2:
	addi $t4, $t4, 1 	#increments every loop in order to go through every part of the array
	add $t1, $t1, $t0 	#increment i from 0 to 8
	ble $t1, $t2, atoi 	#branch to jump back to loop
#integer:
#	addi $t4, $t4, 1 	#increments every loop in order to go through every part of the array
#	add $t1, $t1, $t0 	#increment i from 0 to 8
#	bne $t1, $t2, atoi2 	#branch to jump back to loop

#character:
#	addi $t4, $t4, 1 	#increments every loop in order to go through every part of the array
#	add $t1, $t1, $t0 	#increment i from 0 to 8
#	bne $t1, $t2, atoi 	#branch to jump back to loop

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
