.data
	A: .word 0, 5, 10, 15
.text

main:

# print A[1]
	la $s0, A
	lw $a0, 4($s0)
 	li $v0, 36		#print value from $a0 as decimal
 	syscall



# i=0, sum=0;
# while (i!=4){
# 	sum +=A[i];
# 	i++; 
# }
# print sum

#init
	add $t0,$0,$0 #i
	add $s1,$0,$0 #sum
	
	addi $t3, $0, 4 #constant 4

LOOP:	
	beq $t0, $t3, END	#stick with the core insn format (reg only)
	
	sll $t1, $t0, 2 	#i*4
	add $t1, $t1, $s0 	#addr of A[i]
	lw $t1, 0($t1) 		#load A[i]
	add $s1, $s1, $t1 	#sum += A[i]
	addi $t0, $t0,1		#i++
	j LOOP

END:
	#print sum
	add $a0, $s1, $0
 	li $v0, 36		#print value from $a0 as decimal
 	syscall

exit:
	li $v0, 10
	syscall

#########################################################################
# 	li $v0, 36		#print value from $a0 as decimal
# 	syscall

