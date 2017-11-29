# MIPS Assignment 2
# Programmed by Shelton Allen

	.data

						# Data declaration 	

string_NaN:					# If invalid input, programs outputs this string
	.asciiz "NaN"
string_tooLarge:
	.asciiz "too large"
char_comma:
	.asciiz ","

buffer:							# Reserved space in memory for user input
	.space 1001

	.text



						# Assembly language instructions
main:							# Begin main code
	
	li $v0, 8					# load read string call code
	la $a0, buffer					# load buffer address into $a0
	li $a1, 1001					# define amount of characters to be read
	syscall						# system call for keyboard input
	li $s1, 0					# Initialize register for use
	sub $s7, $a0, 1					# Stores address of byte before string buffer
	
     		# Loop until endcharacter (carriage return or end of line or COMMA*)
inputLoop:
	
	li $t9, 0					
	li $t8, 0					# Counts amount of valid characters in string
	la $t7, validCharacters				# Load address in memory to store valid characters
    


		addiu $t8, $t8, 1				# Keep track of valid character entries 
		bgt $t8, 9, tooManyChars			# Leave loop string is greater than 8 valid characters
		sb $t0, 0($t7)					# Move valid character into validCharacter array
		addiu $t7, $t7, 1				# Put address of next byte of validCharacter array in $t7
		li $s1, 0					# Reset these registers
		li $s0, 0

		j checkString					# Loop back to checkString
		
		# First check each character in a single word
		# If characters are valid, call convertString to convert single string and call displayResult to display the result
		# loop function
endCheckComma:
	
	beqz $t8, inputInvalid				# If no valid characters entered, input is invalid
	# valid: 
		# Call sub
		addi $sp, $sp, -9				# Enough space for 8 characters 
		
		j goToLoop

	inputInvalid:
		li $t1, 1
		addi $sp, $sp, -1
		sb $t1, 0($sp)
		jal subprogram_3
		addi $sp, $sp, 1
		j  goToLoop
tooManyChars:
	li $t1, 2
	addi $sp, $sp, -1
	sb $t1, 0($sp)
	jal subprogram_3
	addi $sp, $sp, 1

goToLoop:
	li $v0, 4				# load print string call code
	la $a0, char_comma			# Print comma
	syscall					# print buffer string
	j inputLoop

endInputLoop:
	beqz $t8, noInput
	valid:
	
	noInput:
	li $t1, 1
	addi $sp, $sp, -1
	sb $t1, 0($sp)
	jal subprogram_3
	addi $sp, $sp, 1	
	
endFunc:
	li $v0, 10

					# Load exit code
	syscall
						# System call to exit


subprogram_1:						# hexToDec
	
	li $s0, 0					# Reset these registers
	li $s1, 0				

     checkChar:
	li $t1, 0x0000003A
	slt $t2, $a0, $t1				# Sets $t2 if t0 <3Ah
	li $t1, 0x0000002F				
	slt $t3, $t1, $a0				# Sets $t3 if $t0 > 2Fh
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of 0-9 ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1
	bne $s1, 1, checkAThroughF
    	li $v0, 2					# Set to 2 to show that inputted character is valid
	subu $v1, $t2, 48
	jr $ra
	
     checkAThroughF:					# Check if byte has code for ASCII A-F
	li $t1, 0x00000047
	slt $t2, $a0, $t1				# Sets $t2 if t0 < 47
	li $t1, 0x00000040				
	slt $t3, $t1, $t0				# Sets $t3 if $t0 > 40
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of A-F ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1
	bne $s1, 1, aThroughfCheck
	li $v0, 2					# Set to 2 to show that inputted character is valid
	subu $v1, $t2, 55
	jr $ra
	
     aThroughfCheck:		# Check if byte has code for ASCII a-f 
	li $t1, 0x00000067
	slt $t2, $a0, $t1				# Sets $t2 if t0 < 67
	li $t1, 0x00000060				
	slt $t3, $t1, $a0				# Sets $t3 if $t0 > 60
	and $s0, $t2, $t3				# Sets $s0 if byte is in range of a-f ASCII 
	addu $s1, $s1, $s0				# If falls in the range, increments $s1
	bne $s1, 1, invalidInput
	li $v0, 2					# Set to 2 to show that inputted character is valid
	subu $v1, $t2, 87
	jr $ra

     invalidInput:
	li $v0, 1					# Set $v0 to 3 if NaN
	jr $ra		

subprogram_2: 						# convertString
	move $t0, $a0					# Address is in $a0
	li $t6, 0
	li $t7, 2					# If valid string, $t7=2
	li $t8, 0					# Count good characters
	li $t9, 0					# Count space after valid character
	move $s7, $ra					# Save return address to $s7
	li $s6, 0					# Store integer
     loop:
	lb $a1, 0($t0)					# Load current to $a1
	beq $a1, 44, exitLoop
	beqz $a1, endProgram				# Check if current character is end of line character, if so end checkString					
	beq $a1, 10, endProgram				# End checkString if current character is carriage return
	bne $a1, 32, notASpace				# Check if current character is a space, if not branch to notASpace
	bne $a1, 9, notASpace				# Check if tab, if not branch to notASpace
      spaceCheck:					# If current character is a space, check where the space is and if the input string is invalid
	addiu $t0, $t0, 1				# Put address of next byte of input string in $a0
	beqz $t8, loop					# check if there was a valid character before the space, if not ignore space
	addiu $t9, $t9, 1				# Record space following valid character entry
	j loop						# Loop back to checkString
	
     notASpace:
	bne $t9, $zero, setNaN				# Check if there was a sequence of character, any amount of spaces, then a character. If so branch to invalid
	jal subprogram_1				# Call subprogram_1 to figure out decimal
	beq $v0, 1, setNaN
	sll $s6, $s6, 1
	addu $s6, $s6, $v1
	addi $t8, $t8, 1
     setNaN:
	li $t7, 1
	j jumpToLoop
     jumpToLoop:
	addiu $t0, $t0, 1
	j loop
    setEndProgram:
	beq $a1, 44, exitLoop
    endProgram:
	li $t6, 1
    exitLoop:
	beq $t7, 1, exitFunc
	bge $t8, 9, setTooLarge
	beqz $t8, setNoInput
	j exitFunc
    setTooLarge:
	li $t7, 0
	j exitFunc
    setNoInput
	li $t7, 1
    exitFunc: 
	addi $sp, $sp, -6
	sb $t7, 0($sp)
	sb $t6, 1($sp)
	sw $s6, 2($sp)
	move $ra, $s7
	jr $ra
	

subprogram_3:						# displayResult:
	
		# Take first single byte from stack, if 1 then should display value passed in stack. 
		# If zero, jump to invalid and display invalid_string "NaN"
	lbu $t0, 0($sp)					# Check first byte of stack, if 1, print NaN, if 2 Too large, if 0
	beq $t0, 2, tooLarge
	beq $t0, 1, notANumber
	lw $t0, 1($sp) 					# Move 4 byte long number to $t0
	bgez $t0, showInt				# If number is positive, show integer
	li $t1, 10					
	divu $t0, $t1					# Divide number by 10
	mflo $t0					# Store quotient in $s0
	mfhi $t1					# Store remainder in $s1
     showInt:
	li $v0, 1					# Load print integer call code
	move $a0, $t0					# Load integer into $a0	
	syscall						# Print integer (if div occurred, print quotient)
	bgez $t0, returnToMain				# End function if no need to show remainder that is in $s1
	move $a0, $t1					# Put remainder in $a0
	syscall						# Print remainder
	j returnToMain					# Return to main
     tooLarge:
	li $v0, 4
	la $a0, string_tooLarge
	syscall
	j returnToMain
     notANumber: 
	li $v0, 4				# load print string call code
	la $a0, string_NaN			# Print error message
	syscall					# print buffer string

	returnToMain: 
		jr $ra

 
	# ONLY EXIT checkString on commas, NL, or Carriage Return
	# Record comma position and starting position
	# if comma
	# check difference between starting and comma position. if greater than 8> display 
	
	
