
.data
	a:	.word 1, 2, 3, 0
.text
#main
#{
#	int a[] = {1,2,3,0}	//*a == a[0] == 1
#	//jal foo
#	foo(a)
#	do something
#	
#}
main:
	la 	$a0, a
	jal 	foo
	j 	exit
#void foo(int vals[]) { 
# while (bar(*vals) > 0) {
# 	vals++; (increment pointer)
# }
#}
foo:
	addi 	$sp, $sp -8
	sw	$ra, 4($sp) 
L1:
	sw	$a0, 0($sp)
	#dereferenc a0
	lw	$a0, 0($a0)
	#call bar
	jal	bar
	#check bar(*vals) > 0
	addi	$t1, $zero, 1
	slt	$t0, $v0, $t1
	beqz	$t0, L2	
	#if ! > 0
	lw	$a0, 0($sp)
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
L2:
	#val++
	lw	$a0, 0($sp)
	addi 	$a0, $a0, 4
	j	L1






bar:
	addi 	$v0, $a0, 0
	jr 	$ra
	
exit:
	li $v0, 10
	syscall
