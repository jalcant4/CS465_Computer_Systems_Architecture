#############################################################################
#  Row-major order traversal of a 2D array of words.
#  Pete Sanderson
#  31 March 2007
#  Edited by Yutao Zhong, April 2023
#
#  To easily observe the row-oriented order, run the Memory Reference
#  Visualization tool with its default settings over this program.
#  You may, at the same time or separately, run the Data Cache Simulator 
#  over this program to observe caching performance.  You can change the 
#  program to be column-by-column traversal and see the difference.
#
#  The C/C++/Java-like equivalent of this MIPS program is:
#     int size1 = 16;
#     int size2 = 16;
#
#     int[size1][size2] data;
#     int value = 0, total = 0;
#     for (int row = 0; row < size1; row++) {
#         for (int col = 0; col < size2; col++) {
#        	data[row][col] = value;
#         	value++;
#         }
#     }
#
#     for (int i=0; i<7; i++){
#     	 for (int row = 0; row < size1; row = row+2) {
#            for (int col = 0; col < size2; col = col+2) {
#           	total += data[row][col];
#            }
#     	 }
#     }
#
#
         .data
data:    .word     0 : 256       # storage for 16*16 matrix of words
         .text

# Initialization of array
         li       $t0, 16         # $t0 = number of rows
         li       $t1, 16         # $t1 = number of columns

init:    move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
#  Each loop iteration will store incremented $t2 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!
init_loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         sw       $t2, data($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past last column, reset column counter and 
#                 increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         bne      $s1, $t1, init_loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 1    # increment row counter
         bne      $s0, $t0, init_loop # not at end of matrix so loop back
         
                  
#traverse and get total                                                     
         li       $t0, 16         # $t0 = number of rows
         li       $t1, 16         # $t1 = number of columns
         li       $t3, 7
         li       $t4, 0
         move     $t2, $zero     # $t2 = the value to be calculated
outer:   move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
#  Each loop iteration will add the next element of matrix to total.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!
loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         lw       $t5, data($s2) # read the value from matrix element
         add      $t2, $t2, $t5  # add value to total
#  Loop control: If we increment past last column, reset column counter and 
#                 increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 2    # increment column counter
         blt      $s1, $t1, loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 2    # increment row counter
         blt      $s0, $t0, loop # not at end of matrix so loop back
         addi     $t4, $t4, 1
         bne      $t4, $t3, outer# i-loop
         
         add      $a0, $t2, $zero#print out total
         li       $v0, 1
         syscall
         
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.
         
