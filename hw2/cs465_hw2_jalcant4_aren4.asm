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


#############################################################
# Code segment
#############################################################

.text

#############################################################
# atoi
#############################################################
#############################################################
# DESCRIPTION OF ALGORITHM 
#
# PUT YOUR ALGORITHM DESCRIPTION HERE
#############################################################
		
.globl atoi
atoi:
	


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

#int strlen(char *s) {
#    int i = 0;
#    while (s[i] != '\0') {
#        i++;
#    }
#    return i;
#}
strlen:
	# $ra // -4($fp)
	# $fp s[0]
	# s[6]
	# ...
	# s[1]
	# $s[0]
	# $sp
	# ...
	#store char s on stack
	addi	$sp, $sp, -24	#Make space for 6 words. Each word is 4 bytes. A char is 1 byte.
	sw 	$fp, 20($sp)	#Store the frame pointer of the stack
	addi 	$fp, $sp, $0	#set up new frame pointer
	addi	$sp, $sp, -4	#Make space for 1 word
	sw	$ra, -4($fp)	#
        
