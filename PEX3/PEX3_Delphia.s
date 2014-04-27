######################################################
# Author: C3C Gavin Delphia
# Date: 4 Apr 12
# Filename: PEX3_Delphia.s
# Purpose: To demonstrate a working PEX3 assignment
# Docuementation: I did not recieve help on this assignment.
######################################################

.data
prompt:		.asciiz	"Enter a number: "
result:		.asciiz	"\nThe sorted list is: "
comma:		.asciiz ", "

.align 2
array: 	.space 2048

.text
###########################################################################################
# Controls the overall flow of the program to include getting the user input, sorting the
# array, outputing the sorted array and quitting the program
###########################################################################################
main:	
	# ask for user input
	li $s0 0		# number of entries
	li $a1 0		# address of where to store the integer
	
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal inputData_loop	# jump and link inputData_loop
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# recursively sort the array
	li $a1 0		# left = 0
	move $a2 $s0		# right array at offset number of entries
	subi $a2 $a2 1		# $a2 = $a2 - 1
	
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal sortArray		# jump and link soryArray
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# print the array out
	li $s1 0		# current entry
	li $a1 0		# offset address
	subi $s0 $s0 1		# subtract 1 from the total entries for the comma fix
	
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal printIntArray	# jump and link printIntArray
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# quit the program
	li $v0 10		# load system call code for terminate program
	syscall			# terminate the program
	
###########################################################################################
# A loop that saves the users integer inputs in the array until a zero is entered
# $a1 offset address
# $s0 total entries the user inputed
###########################################################################################
inputData_loop:
	# display the number prompt
	li $v0 4		# load system call code for print_string
	la $a0 prompt		# address of the prompt string
	syscall			# print the string
	
	# get the number input
	li $v0 5		# load system call code for read integer
	syscall			# get the integer

	beqz $v0 inputData_end	# end loop if user input is zero
	
	# store result in array
	sw $v0 array($a1)	# store the result in array($a1)
	addi $a1 $a1 4		# increment offset
	addi $s0 $s0 1		# increment the entry counter
	
	j inputData_loop	# loop asking for user input
	
###########################################################################################
# Jumps and returns from the input loop
###########################################################################################
inputData_end:
	jr $ra			# jumps back to the return address

###########################################################################################
# Prints the string for the sorted results
###########################################################################################
printIntArray:
	li $v0 4		# load system call code for print_string
	la $a0 result		# address of the result string
	syscall			# print the string

###########################################################################################
# Loops and prints integers in the array until the number of entries is reached
# $a1 offset address
# $s0 total entries the user inputed
# $s1 current entry
###########################################################################################
printIntArray_loop:
	# check if the first integer entered was zero and branch if true
	blt $s0 0 noRecord
	
	# check if only one integer was entered and branch if true
	beqz $s0 printRecord_noComma

	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal printRecord		# jump and link printRecord
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	addi $a1 $a1 4		# increment offset
	addi $s1 $s1 1		# increment counter
	
	# branch to printIntArray_end if the counter $s1 equals the number of entries $s0
	bge $s1 $s0 printIntArray_end	
	
	j printIntArray_loop	# loop

###########################################################################################
# Prints the last entry without the comma after the entry
###########################################################################################
printIntArray_end:
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal printRecord_noComma	# jump and link printRecord_noComma
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
		
	jr $ra			# jumps back to the return address
	
###########################################################################################
# No records were entered so just go back
###########################################################################################
noRecord:
	jr $ra			# jumps back to the return address

###########################################################################################
# Prints a record from the array with comma and space after it
# $a1 offset address
###########################################################################################
printRecord:
	li $v0 1		# load system call code for print_int
	lw $a0 array($a1)	# address of the integer to print
	syscall			# print the integer
	
	li $v0 4		# load system call code for print_string
	la $a0 comma		# address of the comma string
	syscall			# print the string

	jr $ra			# jump to the return address

###########################################################################################
# Prints a record from the array without comma and space after it
# $a1 offset address
###########################################################################################
printRecord_noComma:
	li $v0 1		# load system call code for print_int
	lw $a0 array($a1)	# address of the integer to print
	syscall			# print the integer

	jr $ra			# jump to the return address

###########################################################################################
# Recursively sorts the array
# $a1 left
# $a2 right
# $s2 middle
# $s3 leftIdx
# $s4 rightIdx
# $s5 pivotValue
###########################################################################################
sortArray:
	# if left >= right branch
	bge $a1 $a2 sortArray_end
	
	# initialize the key integers
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal sortArray_ini	# jump and link sortArray_ini
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# while leftIdx < rightIdx
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal while1		# jump and link while1
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# need to add if right Idx < leftIdx
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal ifSwap2		# jump and link ifSwap2
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer
	
	# sortArray(left, leftIdx)
	addi $sp $sp -28	# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	sw $a1 4($sp)		# save $a1 to the stack
	sw $a2 8($sp)		# save $a2 to the stack
	sw $s2 12($sp)		# save $s2 to the stack
	sw $s3 16($sp)		# save $s3 to the stack
	sw $s4 20($sp)		# save $s4 to the stack
	sw $s5 24($sp)		# save $s5 to the stack
	
	move $a2 $s3		# right = leftIdx
	jal sortArray		# jump and link sortArray
	
	lw $ra 0($sp)		# recall the $ra from the stack
	lw $a1 4($sp)		# recall $a1 from the stack
	lw $a2 8($sp)		# recall $a2 from the stack
	lw $s2 12($sp)		# recall $s2 from the stack
	lw $s3 16($sp)		# recall $s3 from the stack
	lw $s4 20($sp)		# recall $s4 from the stack
	lw $s5 24($sp)		# recall $s5 from the stack
	addi $sp $sp 28		# decrease the stack pointer
	
	# sortArray(leftIdx + 1, right)
	addi $sp $sp -28	# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	sw $a1 4($sp)		# save $a1 to the stack
	sw $a2 8($sp)		# save $a2 to the stack
	sw $s2 12($sp)		# save $s2 to the stack
	sw $s3 16($sp)		# save $s3 to the stack
	sw $s4 20($sp)		# save $s4 to the stack
	sw $s5 24($sp)		# save $s5 to the stack
	
	move $a1 $s3		# left = leftIdx
	addi $a1 $a1 1		# left = left + 1
	jal sortArray		# jump and link sortArray
	
	lw $ra 0($sp)		# recall the $ra from the stack
	lw $a1 4($sp)		# recall $a1 from the stack
	lw $a2 8($sp)		# recall $a2 from the stack
	lw $s2 12($sp)		# recall $s2 from the stack
	lw $s3 16($sp)		# recall $s3 from the stack
	lw $s4 20($sp)		# recall $s4 from the stack
	lw $s5 24($sp)		# recall $s5 from the stack
	addi $sp $sp 28		# decrease the stack pointer
	
	
###########################################################################################
# The condition left > right is no longer true so returns
###########################################################################################	
sortArray_end:
	jr $ra			# jump to the return address

###########################################################################################
# Initializes the middle, leftIdx, rightIdx and pivotValue
# $a1 left
# $a2 right
# $s2 middle
# $s3 leftIdx
# $s4 rightIdx
# $s5 pivotValue
###########################################################################################	
sortArray_ini:
	li $t0 2		# $t0 = 2
	add $s2 $a1 $a2 	# middle = left + right
	div $s2 $t0		# middle / 2
	mflo $s2		# middle = quotient
	
	move $s3 $a1		# leftIdx = left
	move $s4 $a2		# rightIdx = right
	
	# address calc
	li $t5 4		# $t5 = 4
	mult $s2 $t5		# multiply $s2 by 4
	mflo $t5		# store multiplication result to $t5
	
	lw $s5 array($t5)	# pivotValue = array(middle)
	jr $ra			# jump to the return address

###########################################################################################
# Loops while leftIdx < rightIdx
# calls two more sub while loops and the conditional ifSwap1
# $s3 leftIdx
# $s4 rightIdx
###########################################################################################	
while1:
	bge $s3 $s4 while1_end	# when leftIdx >= rightIdx break the loop
	
	# while array(leftIdx) < pivotValue and leftIdx < rightIdx
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal while2		# jump and link while2
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer		
	
	# while array(rightIdx) > pivotValue and rightIdx > leftIdx
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal while3		# jump and link while3
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer	
	
	# if leftIdx < rightIdx
	addi $sp $sp -4		# increase the stack pointer
	sw $ra 0($sp)		# save the return address into the stack
	jal ifSwap1		# jump and link ifSwap
	lw $ra 0($sp)		# recall the $ra from the stack
	addi $sp $sp 4		# decrease the stack pointer	
	
	j while1		# loop

###########################################################################################
# The condition leftIdx < rightIdx is no longer true so the loop returns
###########################################################################################	
while1_end:
	jr $ra 			# jump to the return address

###########################################################################################
# Loops while array at offset leftIdx < pivotValue and leftIdx < rightIdx; 
# Increments leftIdx by 1
# $s3 leftIdx
# $s4 rightIdx
# $s5 pivotValue
# $t2 array(leftIdx)
###########################################################################################	
while2:
	# address calc
	li $t5 4		# $t5 = 4
	mult $s3 $t5		# multiply $s3 by 4
	mflo $t5		# store multiplication result to $t5

	lw $t2 array($t5)	# set $t2 = array at offset $s3
	
	bge $t2 $s5 while2_end	# branch if $t2 is greater than or equal to $s5
	bge $s3 $s4 while2_end	# branch if $s3 is greater than or equal to $s4
	
	addi $s3 $s3 1		# leftIdx = leftIdx + 1
	j while2		# loop
	
###########################################################################################
# The conditions array at leftIdx < pivotValue and leftIdx < rightIdx 
# are no longer true so return
###########################################################################################	
while2_end:
	jr $ra			# jump to the return address
	
###########################################################################################
# Loops while array at offset rightIdx > pivotValue and rightIdx > leftIdx; 
# Decreases rightIdx by 1
# $s3 leftIdx
# $s4 rightIdx
# $s5 pivotValue
# $t2 array(rightIdx)
###########################################################################################	
while3:
	# address calc
	li $t5 4		# $t5 = 4
	mult $s4 $t5		# multiply $s4 by 4
	mflo $t5		# store multiplication result to $t5

	lw $t2 array($t5)	# set $t1 = array at offset $s4
	ble $t2 $s5 while3_end 	# branch if $t2 is less than or equal to $s5
	ble $s4 $s3 while3_end	# branch if $s4 is less than or equal to $s3
	
	subi $s4 $s4 1		# rightIdx = rightIdx - 1
	j while3		# loop
	
###########################################################################################
# The conditions array at offset rightIdx > pivotValue and rightIdx > leftIdx 
# are no longer true so the loop returns
###########################################################################################	
while3_end:
	jr $ra			# jump to the return address
	
###########################################################################################
# Swaps the array at offset leftIdx with array at offset rightIdx only
# if leftIdx < rightIdx otherwise branches and returns
# $s3 leftIdx
# $s4 rightIdx
# $t5 leftIdx * 4
# $t6 rightIdx *4
# $t1 array(leftIdx)
# $t2 array(rightIdx)
###########################################################################################		
ifSwap1:
	#branch if $s3 is greater than or equal to $s4
	bge $s3 $s4 ifSwap1_noswap	
	
	# address calc
	li $t5 4		# $t5 = 4
	mult $s3 $t5		# multiply $s3 by 4
	mflo $t5		# store multiplication result to $t5
	
	# address calc
	li $t6 4		# $t6 = 4
	mult $s4 $t6		# multiply $s4 by 4
	mflo $t6		# store multiplication result to $t6
	
	# swap array(leftIdx) with array(rightIdx)
	lw $t1 array($t5)	# set $t1 = array(leftIdx)
	lw $t2 array($t6)	# set $t2 = array(rightIdx)
	sw $t1 array($t6)	# set array at offset $t6 = $t1
	sw $t2 array($t5)	# set array at offset $t5 = $t2
	
	jr $ra			# jump to the return address
	
###########################################################################################
# The condition leftIdx < rightIdx was not met so return
###########################################################################################		
ifSwap1_noswap:
	jr $ra			# jump to the return address

###########################################################################################
# Swaps leftIdx with rightIdx if rightIdx < leftIdx otherwise branches and returns
# $s3 leftIdx
# $s4 rightIdx
###########################################################################################	
ifSwap2:
	# branch if $s4 is greater than or equal to $s3
	bge $s4 $s3 ifSwap2_noswap	
	
	# swap leftIdx with rightIdx
	move $t1 $s3		# set $t1 = $s3
	move $t2 $s4		# set $t2 = $s4
	move $s3 $t2		# set $s3 = $t2
	move $s4 $t1		# set $s4 = $t1
	
	jr $ra 			# jump to the return address
	
###########################################################################################
# The condition rightIdx < leftIdx was not met so return
###########################################################################################		
ifSwap2_noswap:
	jr $ra			# jump to the return address
