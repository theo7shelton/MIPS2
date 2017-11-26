# MIPS Assignment 2
# Programmed by Shelton Allen

	.data

						# Data declaration 	

invalid_inputStr:					# If invalid input, programs outputs this string
	.asciiz "NaN"
buffer:							# Reserved space in memory for user input
	.space 1001
validCharacters:					# Reserved space in memory for valid characters in user input
	.space 8

	.text



						# Assembly language instructions
main:							# Begin main code
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 1001					# define amount of characters to be read
	syscall						# system call for keyboard input
	li $s1, 0					# Initialize register for use
	
     		# Loop until endcharacter (carriage return or end of line or COMMA*)
inputLoop:
	
	li $t9, 0					
	li $t8, 0					# Counts amount of valid characters in string
	la $t7, validCharacters				# Load address in memory to store valid characters
	li $t6, 0					# counts amount of characters
	
	
	checkString: 				# Checks to see if string is valid. If not, branches to code to display error message to user=

		# If comma, jump to subprogram_3 and pass amt of valid characters in stack

		lb $t0, 0($a0)					# Load byte into $t0

		li $t1, 44					# ASCII Decimal for comma
		beq $t0, $t1, endCheck 				# Check if byte is comma

		beqz $t0, endCheck				# Check if current character is end of line character, if so end checkString
		li $t1, 10					# Load return carriage decimal into $t1
		beq $t0, $t1, endCheck				# End checkString if current character is carriage return

		li $t1, 0x00000020				# Load space character in $t1
		bne $t1, $t0, notASpace				# Check if current character is a space, if not branch to notASpace
      	spaceCheck:					# If current character is a space, check where the space is and if the input string is invalid
		addiu $a0, $a0, 1				# Put address of next byte of input string in $a0
		beqz $t8, checkString				# check if there was a valid character before the space, if not ignore space
		addiu $t9, $t9, 1				# Record space following valid character entry
		j checkString					# Loop back to checkString
	
   	  notASpace:
		 bne $t9, $zero, endCheckComma			# Check if there was a sequence of character, any amount of spaces, then a character. If so branch to invalid
			# Check if in range of 0-9 ASCII		
		li $t1, 0x0000003A
		slt $t2, $t0, $t1				# Sets $t2 if t0 <3Ah
		li $t1, 0x0000002F				
		slt $t3, $t1, $t0				# Sets $t3 if $t0 > 2Fh
		and $s0, $t2, $t3				# Sets $s0 if byte is in range of 0-9 ASCII 
		addu $s1, $s1, $s0				# If falls in the range, increments $s1
			# Check if byte has code for ASCII a-f 
		li $t1, 0x00000067
		slt $t2, $t0, $t1				# Sets $t2 if t0 < 67
		li $t1, 0x00000060				
		slt $t3, $t1, $t0				# Sets $t3 if $t0 > 60
		and $s0, $t2, $t3				# Sets $s0 if byte is in range of a-f ASCII 
		addu $s1, $s1, $s0				# If falls in the range, increments $s1

			# Check if byte has code for ASCII A-F
		li $t1, 0x00000047
		slt $t2, $t0, $t1				# Sets $t2 if t0 < 47
		li $t1, 0x00000040				
		slt $t3, $t1, $t0				# Sets $t3 if $t0 > 40
		and $s0, $t2, $t3				# Sets $s0 if byte is in range of A-F ASCII 
		addu $s1, $s1, $s0				# If falls in the range, increments $s1
	
		beqz $s1, invalid				# If no valid characters, branch to invalid
			# If valid, do the following
		addiu $t8, $t8, 1				# Keep track of valid character entries 
		sb $t0, 0($t7)					# Move valid character into validCharacter array
		addiu $t7, $t7, 1				# Put address of next byte of validCharacter array in $t7
     		addiu $a0, $a0, 1				# Put address of next byte of input string in $a0
		li $s1, 0					# Reset these registers
		li $s0, 0

		j checkString					# Loop back to checkString
		
# First check each character in a single word
		# If characters are valid, call convertString to convert single string and call displayResult to display the result
		# loop function
endCheckComma:
	
	beqz $t8, noInputBeforeComma				# If no valid characters entered, input is invalid
	
	valid: 
		# Call sub
		addi $sp, $sp, -9				# Enough space for 8 characters 
		
	noInputBeforeComma:
		addi $sp, $sp, -1
		sb 0, 0($sp)
		jal subprogram_3

endInputLoop:
	beqz $t8, 
	
endFunc:
	li $v0, 10

					# Load exit code
	syscall
						# System call to exit


subprogram_1:						# hexToDec
	

subprogram_2: 						# convertString


subprogram_3:						# displayResult:
	
		# Take first single byte from stack, if 1 then should display value passed in stack. 
		# If zero, jump to invalid and display invalid_string "NaN"
 
	invalid: 
		li $v0, 4					# load print string call code
		la $a0, invalid_inputStr			# Print error message
		syscall						# print buffer string
		jr $ra 						# return	
	
