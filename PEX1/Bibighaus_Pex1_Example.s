######################################################
# Author: Lt Col Bibighaus
# Date: 22 Feb 11
# Filename: Bibighaus_PEX_1
# Purpose: Demonstrate coding standards for CS-351
##		
######################################################

.data

opening: 	.asciiz "Welcome!\n"
question:	.asciiz "How many times do you want to print the message?\n"
message:  	.asciiz "Coding in assembly is fun!\n"
bye:   		.asciiz "\nHave a nice day!\n"

.text
main:
################
# Registers used:
# s0 - number of times to print
# s1 - loop counter
################
	

	li $v0 4	# load system call code for print_string	
	la $a0 opening	# address of the opening string
	syscall		# print the message
	
	li $v0 4	# load system call code for print_string
	la $a0 question	# address of the question string
	syscall		# print the message
	
	li $v0 5	# load system call code for read integer
	syscall		# get the integer
	move $s0 $v0	# store the result in $s0
		
######################################################
# PrintLoop: 
# Function: Prints the loop three times
# Inputs: $a0 - Address of the location in memory
# Outputs: $v0 - 1 if successfully added, 0 if unsuccessful
######################################################
	li $s1 0	#initialize the loop counter to 0
PrintLoop:
	bge $s1 $s0 EndLoop
	
	# print message
	li $v0 4	# load system call code for print_string
	la $a0 message	# address of the message string
	syscall		# print the message
	
	addi $s1 $s1 1  # increment the loop counter
	j PrintLoop     # loop back to the beginning
	
EndLoop:	
	li $v0 4	# load system call code for print_string
	la $a0 bye	# address of the bye string
	syscall		# print the message
	
	li $v0 10	# exit the program
	syscall
# end main