# MIPS Assignment 1
# Programmed by Shelton Allen

	.data

						# Data declaration 	

invalid_inputStr:					# If invalid input, programs outputs this string
	.asciiz "Invalid hexadecimal number."
buffer:							# Reserved space in memory for user input
	.space 9
validCharacters:					# Reserved space in memory for valid characters in user input
	.space 8

	.text



						# Assembly language instructions
main:							# Begin main code
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 9					# define amount of characters to be read
	syscall						# system call for keyboard input
	
	li $s1, 0					# Initialize registers for use
	li $t9, 0
	li $t8, 0
	la $t7, validCharacters				# Load address in memory to store valid characters
	
     	# Loop until endcharacter (carriage return or end of line)
	# First check each character in a single word
	# If characters are valid, call convertString to convert single string and call displayResult to display the result
	# loop function
endFunc:
	li $v0, 10

					# Load exit code
	syscall
						# System call to exit


hexToDec:						# Subprogram 1
	

convertString: 						# Subprogram 2


displayResult:						# Subprogram 3
		# Take first single byte from stack, if 1 then should display value passed in stack. 
		# If zero, jump to invalid and display invalid_string "NaN"

	invalid: 
		li $v0, 4					# load print string call code
		la $a0, invalid_inputStr			# Print error message
		syscall						# print buffer string
		jr $ra 						# return	
	