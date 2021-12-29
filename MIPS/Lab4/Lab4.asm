#########################################################################################################################################################################################
#John Sanli 
#Jsanli
#Fall 2020
#Lab 4
#The program will accept up to 8 program arguments in HEX format. The numbers will range from 0x000 up to 0xFFF. These numbers will be converted to decimals.
# The maximum number will be printed on screen in decimal format
#
#Lab4.asm
#
#Run Code by Launching Mars. Then open asm file in Mars. Run -> Assemble Execute -> Green Arrow Then follow instructions give to you by the program.  
########################################################################################################################################################################################
.data
	proarg: .asciiz "Program arguments: \n"
	intvals: .asciiz "Integer values:\n"
	maxval: .asciiz "Maximum value:\n"
	space: .asciiz " "
	twonl: .asciiz " \n\n"
	nl: .asciiz "\n"
.text
	#REGISTER USAGE
	# $v0: Load Imediate For Syscalls
	# $a0: Argument For Syscalls and Length of Program Arguments
	# $a1: Program Arguments 
	# $t0: Stores $a0 so as $a0 is used for various arguments the original length of the Program Arguments isn't lost
	# $t1: Stores $a1 so as iteration occurs the original Program Arguments isn't lost 
	# $t2: iterator for going through the various words
	# $t3: Register to load words to
	# $t4: Register for the 1st bit in the Hex
	# $t5: Register for the 2nd bit in the Hex
	# $t6: Register for the 3rd bit in the Hex
	# $t7: Register for each decimal value
	# $t8: Stores the greatest decimal value
	
	move $t0, $a0									    # Stores number of program arguments in a temporary register
	move $t1, $a1									    # Stores program arguments as words in a temporary register
	addi $t2, $zero, 0								    # Initializes $t2 as 0
	addi $t7, $zero, 0								    # Initializes $t7 as 0									
	addi $t8, $zero, 0								    # Initializes $t8 as 0
	
	program_arguments:
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, proarg								    # Sets string prgarg to $a0 argument register
		syscall									    # Prints proarg
	
	hex_arguments:
		beq $t0, $t2, integer_values						    # Jumps to integer_values once the iterator equals the number of program arguments
		
		li $v0, 4								    # Initializes $v0 as String Output	
		lw $t3, 0($t1)								    # Loads word at $t1 to $t3
		la $a0, ($t3)								    # Sets register $t0 to $a0 argument register
		syscall									    # Prints the intended program argument
		
		li $v0, 4								    # Initializes $v0 as String Output
		la $a0, space								    # Sets space to $a0 argument register
		syscall								            # Prints a space
		
		addi $t1, $t1, 4							    # Adds 4 to t1, allowing the program to later refer to the next word
		addi $t2, $t2, 1							    # Adds 1 to the iterator register, allows the while loop to function correctly
		
		j hex_arguments								    # Allows the loop to repeat itself
			
	integer_values:
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, twonl								    # Sets string twonl to $a0 argument register
		syscall									    # Prints twonl
		
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, intvals								    # Sets string intvals to $a0 argument register
		syscall									    # Prints intvals
		
		move $t1, $a1								    # Resets $t1 to the original Program Arguments 
		sub $t2, $t2, $t2                                                           # Resets the iterator to 0
		
	integer_arguments:
		beq $t0, $t2, maximum							    # Once the iterator is equal to the numer of Program arguments the function exits
		
		lw $t3, 0($t1)								    # Loads the word from $a1 to $t3 
		lb $t4, 2($t3)								    # Loads the third bit from the $t3 word
		lb $t5, 3($t3)								    # Loads the fourth bit from the $t3 word
		beq $t5, 0, onebit						            # Checks if the $t5 is null, if so all this code below in the function isn't necessary and something more efficient is run and it eliminates any possible overflow errors	
		lb $t6, 4($t3)								    # Loads the fifth bit from the $t3 word
		
		ift4:
			bgt $t4, 64, elset4                                                 # If the character is a letter the program jumps to the else
			addi $t4, $t4, -48						    # Translates the character from ascii to binary
			j ift5                                                              # Jumps to the next if statement
		elset4:
			addi $t4, $t4, -55						    # Translates the character from ascii to binary
		ift5:
			bgt $t5, 64, elset5                                                 # If the character is a letter the program jumps to the else
			addi $t5, $t5, -48						    # Translates the character from ascii to binary
			j ift6                                                              # Jumps to the next if statement
		elset5:
			addi $t5, $t5, -55						    # Translates the character from ascii to binary
		ift6:
			bgt $t6, 64, elset6                                                 # If the character is a letter the program jumps to the else
			addi $t6, $t6, -48						    # Translates the character from ascii to binary
			j convertt6                                                         # Jumps to the next function
		elset6:
			addi $t6, $t6, -55						    # Translates the character from ascii to binary	
		
		convertt6:
			blt $t6, 0, convertt5						    # If the fifth bit is a null the program jumps to check if the fourth bit is a null
			
			move $t7, $t6							    # Moves the least significant number to the total register
			mul $t5, $t5, 16					            # Multiples the middle bit by 16^1
			add $t7, $t7, $t5						    # Adds the multiplied bit to the total
			mul $t4, $t4, 256						    # Multiples the most significant bit by 16^2
			add $t7, $t7, $t4						    # Adds the multiplied bit to the total
			
			j print								    # Jumps to print, skipping the functions that apply to smaller hex values 
		convertt5:
			blt, $t5, 0, convertt4                                              # If the fourth bit is a null the program jumps to just output the most significant bit
			
			move $t7, $t5							    # Moves the least significant bit to the total register
			mul $t4, $t4, 16						    # Multiplies the most signifcant bit by 16^1
			add $t7, $t7, $t4						    # Adds the multiplied bit to the total 
			
			j print								    # Jumps to print, skipping the functions that apply to single digit hex values
		convertt4:
			move $t7, $t4							    # Assigns $t4 to the total register
	
		print:
			li $v0, 1							    # Initializes $v0 to integer output
			la $a0, ($t7)                                                       # Sets register $t0 to $a0 argument register
			syscall								    # Prints t7 as an integer 
		
			li $v0, 4							    # Initializes $v0 to string output
			la $a0, space                                                       # Sets space to $a0 argument register
			syscall      							    # Prints space
		
		addi $t1, $t1, 4							    # Adds 4 to# Adds 4 to t1, allowing the program to later refer to the next word
		addi $t2, $t2, 1							    # Adds 1 to the iterator register, allows the while loop to function correctly
		
		maximumcheck: 
			bgt $t8, $t7, integer_arguments 				    # Skips this function if $t8 is arleady the greatest
			move $t8, $t7							    # Assigns t7 to t8 when t7 is greater
		
		j integer_arguments							    # Iterates the loop
		
	onebit:
		if:
			bgt $t4, 64, else                                                   # If the character is a letter the program jumps to the else
			addi $t4, $t4, -48						    # Translates the character from ascii to binary
			j mover                                                             # Jumps to the next if statement
		else:
			addi $t4, $t4, -55						    # Translates the character from ascii to binary	
		mover:
			move $t7, $t4							    # Assigns t4 to t7, as there is only one character
		
		j print		
	maximum:
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, twonl								    # Sets string twonl to $a0 argument register
		syscall									    # Prints twonl
			
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, maxval								    # Sets string maxval to $a0 argument register
		syscall									    # Prints maxval
		
		li $v0, 1								    # Initializes $v0 as String Output	
		la $a0, ($t8) 								    # Sets $t8 to $a0 argument register
		syscall									    # Prints maximum value
		
		li $v0, 4								    # Initializes $v0 as String Output	
		la $a0, nl								    # Sets string nl to $a0 argument register
		syscall									    # Prints nl
	exit:	
		li $v0, 10						    		    # Initializes $v0 to Exit
		syscall							    		    # Exits the program
