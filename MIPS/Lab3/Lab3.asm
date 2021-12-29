#########################################################################################################################################################################################
#John Sanli 
#Jsanli
#Fall 2020
#Lab 3
#This lab will introduce you to the MIPS ISA using MARS. You will write a program with several nested loops to print variable-sized ASCII diamonds and a sequence of embedded numbers.
#In addition, this lab will introduce you to several different syscalls to incorporate I/O into your program.
#
#Lab3.asm
#
#Run Code by Launching Mars. Then open asm file in Mars. Run -> Assemble Execute -> Green Arrow Then follow instructions give to you by the program.  
########################################################################################################################################################################################


.data
	prompt: .asciiz "Enter the height of the pattern:	"
	newline: .asciiz "\n"
	tryagain: .asciiz "Invalid Entry!"
	space: .asciiz " 	"
	ast: .asciiz "*	"
	tab: .asciiz "	"
.text
	#REGISTER USAGE
	# $v0: Load Imediate For Syscalls
	# $a0: Argument For Syscalls
	# $t0: User input
	# $t1: Number to be Inlcuded in Pyramid
	# $t2: Asterisk Counter
	# $t3: One, Used as a comparison in beq
	# $t4: Temporary $t0 for usage in loops
	# $t5: Tempoaray $t2 for usage in loops
	
	li $v0, 4								    # Initializes $v0 as String Output	
	la $a0, prompt								    # Sets string prompt to $a0 argument register
	syscall								    	    # Prints prompt
	
	li $v0, 5								    # Initializes $v0 As Integer Input
	syscall								            # Takes Input from User
	
	move $t0, $v0								    # Sets register $t0 as equivalent to $v0, or the input
	
	while:
		bgt $t0, 0, exit						    # Exits loop when input is greater than 0
		
		li $v0, 4							    # Initializes $v0 as String Output
		la $a0, tryagain						    # Sets string tryagain to $a0 argument register
		syscall								    # Prints tryagain
		
		li $v0, 4							    # Initializes $v0 as String Output
		la $a0, newline						            # Sets string newline to $a0 argument register
		syscall								    # Prints a new line
		  
		li $v0, 4							    # Initializes $v0 as String Output
		la $a0, prompt							    # Sets string prompt to $a0 argument register
		syscall								    # Prints Promt
	
		li $v0, 5							    # Initializes $v0 as Intiger Input
		syscall								    # Takes Inpuut From User
	
		move $t0, $v0							    # Sets register $t0 as equivalent to $v0, or the input
		
		j while								    # Returns to the top of the while loop
	exit:		
		addi $t1, $zero, 1						    # Sets t1 to 1
		addi $t2, $zero, -1 						    # Sets t2 to -1
		addi $t3, $zero, 1						    # Sets t3 to 1
		whilerows:								    
			beqz $t0, exitrows					    # Exits the loop when $t0 is equal to 0
			
			move $t4, $t0						    # Sets temporary placeholder $t4 to $t0
			whilespaces:
				beq $t3, $t4, exitspaces 			    # Exits the loop when $t4 equals one
				
				li $v0, 4					    # Initializes $v0 as String Output
				la $a0, space					    # Sets string space to $a0 argument register
				syscall						    # Prints a Space
				
				subi $t4, $t4, 1				    # Increments $t4 by -1
				
				j whilespaces					    # Returns to the top of the loop, creating a true while
			exitspaces:
				li $v0, 1					    # Initializes $v0 as Integer Output
				move $a0, $t1					    # Sets $a0 argument register to %t0
				syscall  					    # Prints $t1
				
				li $v0, 4					    # Initializes $v0 as String Output
				la, $a0, tab					    # Sets string tab to $a0 argument register
				syscall						    # Prints a Tab
				
				addi $t1, $t1, 1				    # Increments $t0 by one
				
				if:
					beq $t2, -1, else	 		    # Goes to else and skips whilestars when $t2 = -1 which is only on the first row, where there are no asterisks
					
					move $t5, $t2				    # Sets temporary $t5 to the value of $t2, creating a temporary variable for the next while loop
					whilestars:
						beqz $t5, exitstars                 # Exits the loop when $t5 is equal to 0
							       	    
						li $v0, 4			    # Initializes $v0 as String Output
						la $a0, ast			    # Sets string ast to $a0 argument register
						syscall				    # Prints an asterisk
						
						subi $t5, $t5, 1		    # Interates $t5 by negative one
						
						 j whilestars 			    # Returns to the top of the loop, making this a true while loop
					exitstars:
						li $v0, 1			    # Initializes $v0 as Integer Output
						move $a0, $t1			    # Sets $a0 argument register to %t0
						syscall 			    # Prints $t1
						 
						li $v0, 4			    # Initializes $v0 as String Output
						la, $a0, tab			    # Sets string tab to $a0 argument register
						syscall				    # Prints a tab
						
						addi $t1, $t1, 1		    # Increments $t1 by one
						
						j else			       	    # Jumps to else, allowing every row to act like the first, except for this one while loop
				else:
					move $t4, $t0				    # Sets temporary $t4 to the current value of $t0
					whilespaces2:
						beq $t3, $t4, exitspaces2      	    # Exits the loop when $t4 is equal to one
						
						li $v0, 4			    # Initializes $v0 as String Output
						la $a0, space			    # Sets string space to $a0 argument register
						syscall				    # Prints a space
				
						subi $t4, $t4, 1		    # Increments $t4 by neagtive one
						
						j whilespaces2			    # Returns to the beginning of the while loop
					exitspaces2:
						li $v0, 4			    # Initializes $v0 as String Output
						la $a0, newline			    # Sets string newline to $a0 argument register
						syscall				    # Prints a new line, beginning the next row of the pyramiid
						
						addi $t0, $t0, -1		    # Increments $t0 by negative one
						addi $t2, $t2, 2		    # Increments $t2 by 2
						
						j whilerows			    # Returns to the top of the entire loop
					
		exitrows:
			li $v0, 10						    # Initializes $v0 to Exit
			syscall							    # Exits the program
