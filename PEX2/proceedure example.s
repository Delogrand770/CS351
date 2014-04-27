.text

#############################
# Author: Lt Col David Bibighaus
# Date: 28 Feb 11
# Filename: Lesson19.s
# Purpose: Demonstrate 
#############################
main:

	li $t0 5		# Load a number that we can double
	
	move $a0 $t0		# place the number in to the arguement 0 register
	
	addi $sp $sp -4		# Decrement the stack pointer by 4 to make room to store $ra
	sw $ra 0($sp)		# Store the return address register
	jal double		# Call double
	lw $ra 0($sp)		# Restore the return address register
	addi $sp $sp 4		# "Pop" it from the stack

	move $a0 $v0 		# Get the output from proc and move it to the input of the sys call
	li $v0 1		# Prepare for the Print Integer Syscall
	syscall			# Execute the call
	
	li $v0 10		# Prepare for the Exit Syscall
	syscall			# Execute the call
	
#############################
# Double: 
# Function: Doubles the input
# Inputs: $a0 - Number to double
# Outputs: $v0 - Doubled number
#############################	
double:
	sll $v0 $a0 1	
	jr $ra