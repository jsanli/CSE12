#########################################################################################################################################################################################
#John Sanli 
#Jsanli
#Fall 2020
#Lab 5
#In this lab, you will implement functions that perform some primitive graphics operations on a small simulated display. 
#These functions will clear the entire display to a color, display rectangular and diamond shapes using a memory-mapped bitmap graphics display tool in MARS.
#
#Lab5.asm
#
#Run Code by Launching Mars. Then open asm file in Mars. Run -> Assemble Execute -> Green Arrow Then follow instructions give to you by the program.  
#Use lab5_f20_test.asm to run the run the program itself, as this lab doesn't output anything on its own
########################################################################################################################################################################################
#Fall 2020 CSE12 Lab5 Template File

## Macro that stores the value in %reg on the stack 
##  and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#  loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

# Macro that takes as input coordinates in the format
# (0x00XX00YY) and returns 0x000000XX in %x and 
# returns 0x000000YY in %y
.macro getCoordinates(%input %x %y)
	div %x, %input, 65536
	rem %y, %input, 65536 
.end_macro

# Macro that takes Coordinates in (%x,%y) where
# %x = 0x000000XX and %y= 0x000000YY and
# returns %output = (0x00XX00YY)
.macro formatCoordinates(%output %x %y)
	mul %x, %x, 65536
	add %output, %x, %y
.end_macro 


.data
originAddress: .word 0xFFFF0000


.text
#REGISTER USAGE
	# $v0: Load Imediate For syscall
	# $a0: Argument passed into functions
	# $a1: Argument passed into functions
	# $a2: Argument passed into functions
	# $t0: Temporary register use varies from function to function
	# $t1: Temporary register use varies from function to functiont 
	# $t2: Temporary register use varies from function to function
	# $t3: Temporary register use varies from function to function
	# $t4: Temporary register use varies from function to function
	# $t5: Temporary register use varies from function to function
	# $t6: Temporary register use varies from function to function
	# $t7: Temporary register use varies from function to function
	# $t8: Temporary register use varies from function to function
	# $t9: Temporary register use varies from function to function
j done
    
done: nop
	li $v0 10 
	syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
#Clear_bitmap: Given a color, will fill the bitmap display with that color.
#   Inputs:
#    $a0 = Color in format (0x00RRGGBB) 
#   Outputs:
#    No register outputs
#    Side-Effects: 
#    Colors the Bitmap display all the same color
#*****************************************************
clear_bitmap: nop
	lw $t0, originAddress								#loads word origin address to temporary register 0
	move $t1, $a0									#moves color value to a temporary register
	add $t2, $zero, 0								#sets $t2 to 0 so it can be used as an iterator 
	loop:	
		beq $t2, 16129, exit							#exits when the counter is equivalent to 127^2, and every pixel has been colored
		sw $t1, ($t0)								#send color to the desired pixel
		add $t0, $t0, 4								#iterates to the next pixel
		add $t2, $t2, 1								#increases the iterator by one
		j loop
	exit:		  
		jr $ra									#jumps to where the loop was called upon exiting

#*****************************************************
# draw_pixel:
#  Given a coordinate in $a0, sets corresponding value
#  in memory to the color given by $a1	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#    $a1 = color of pixel in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#*****************************************************
draw_pixel: nop
	move $t0, $a0									#assigns pixel coordinates to a temporary register
	move $t3, $a1									#assigns color to a temporary register
	getCoordinates($t0, $t1, $t2)							#refers to the get Coordinates macro to get both the x and y coordinates from 0x00XX00XX00 form
	mul $t2, $t2, 128								#multiplies the y by 128
	add $t0, $t2, $t1 								#adds the multiplied y to the x
	mul $t0, $t0, 4									#multiply by 4 to account for iterating over bits
	lw $t4, originAddress								#loads origin address word to a register
	add $t0, $t0, $t4								#adds the hex value to the value of the origin to make sure it fits on the grid
	sw $t3, ($t0)									#colors in the desired pixel
	jr $ra										#jumps to where the function was called
#	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of pixel in format (0x00XX00YY)
#   Outputs:
#    Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	move $t0, $a0									#assigns pixel coordinates to a temporary register
	getCoordinates($t0, $t1, $t2)							#refers to the get Coordinates macro to get both the x and y coordinates from 0x00XX00XX00 form
	mul $t2, $t2, 128								#multiplies the y by 128
	add $t0, $t2, $t1 								#adds the multiplied y to the x 
	mul $t0, $t0, 4									#multiply by 4 to account for iterating over bits
	lw $t4, originAddress								#loads origin address word to a register
	add $t0, $t0, $t4								#adds the hex value to the value of the origin to make sure it fits on the grid
	lw $v0, ($t0)									#loads the color at the desired pixel to $v0
	jr $ra										#jumps to where the function was called

#*****************************************************
#draw_rect: Draws a rectangle on the bitmap display.
#	Inputs:
#		$a0 = coordinates of top left pixel in format (0x00XX00YY)
#		$a1 = width and height of rectangle in format (0x00WW00HH)
#		$a2 = color in format (0x00RRGGBB) 
#	Outputs:
#		No register outputs
#*****************************************************
draw_rect: nop
	move $t0, $a0									#assigns pixel coordinates to a temporary register
	getCoordinates($t0, $t1, $t2)							#refers to the get Coordinates macro to get both the x and y coordinates from 0x00XX00XX00 form
	mul $t2, $t2, 128								#multiplies the y by 128
	add $t0, $t2, $t1 								#adds the multiplied y to the x  
	mul $t0, $t0, 4									#multiply by 4 to account for iterating over bits
	lw $t3, originAddress								#loads origin address word to a register
	add $t0, $t0, $t3								#adds the hex value to the value of the origin to make sure it fits on the grid
	move $t4, $a2									#assigns color to a temporary register
	move $t3, $a1									#assigns width and height to a temporary register
	getCoordinates($t3, $t5, $t6)							#uses macro to seperate the width and height
	move $t7, $zero									#initializes $t7 as 0
	move $t8, $zero									#initializes $t8 as 0
	move $t9, $zero									#initializes $t9 as 0 
	addi $t9, $t9, 512								#adds the length of a full row to $t9 
	mul $t5, $t5, 4									#multiplies the width by 4 to account for how mips moves through words
	sub $t9, $t9, $t5								#subtracts the width from a row length to account for distance taken up by the previous rectangle
	div $t5, $t5, 4									#divides by 4 to reset the counter for purposes in the loops below  
	row:	
		beq $t7, $t5, column							#goes to create a new row once the counter is equal to the width of the rectangle
		sw $t4, ($t0)								#assigns the color to the designated pixel
		add $t0, $t0, 4								#iterates to the next pixel
		add $t7, $t7, 1								#iterates the counter for the purposes of the loop
		j row									#reenters the loop from the top
	column:	
		beq $t8, $t6, exitrect							#exits if the number of existing rows is equalivalent to the height
		move $t7, $zero								#resets the width counter as 0
		addi $t8, $t8, 1							#adds 1 to the counter
		add $t0, $t0, $t9 							#iterates the the next row
		j row									#returns to the new row
	exitrect:		  	
		jr $ra									#jumps to where the function was called

#***********************************************
# draw_diamond:
#  Draw diamond of given height peaking at given point.
#  Note: Assume given height is odd.
#-----------------------------------------------------
# draw_diamond(height, base_point_x, base_point_y)
# 	for (dy = 0; dy <= h; dy++)
# 		y = base_point_y + dy
#
# 		if dy <= h/2
# 			x_min = base_point_x - dy
# 			x_max = base_point_x + dy
# 		else
# 			x_min = base_point_x - floor(h/2) + (dy - ceil(h/2)) = base_point_x - h + dy
# 			x_max = base_point_x + floor(h/2) - (dy - ceil(h/2)) = base_point_x + h - dy
#
#   	for (x=x_min; x<=x_max; x++) 
# 			draw_diamond_pixels(x, y)
#-----------------------------------------------------
#   Inputs:
#    $a0 = coordinates of top point of diamond in format (0x00XX00YY)
#    $a1 = height of the diamond (must be odd integer)
#    $a2 = color in format (0x00RRGGBB)
#   Outputs:
#    No register outputs
#***************************************************
draw_diamond: nop
	move $t0, $a0									#assigns pixel coordinates to a temporary register
	move $t1, $a1									#assigns height to a temporary register 
	move $t2, $a2									#assigns color to a temporary register
	getCoordinates($t0, $t3, $t4)							#refers to the get Coordinates macro to get both the x and y coordinates from 0x00XX00XX00 form
	mul $t4, $t4, 128								#multiplies the y by 128
	add $t0, $t3, $t4  								#adds the multiplied y to the x 
	mul $t0, $t0, 4									#multiply by 4 to account for iterating over bits
	lw $t5, originAddress								#loads origin address word to a register
	add $t0, $t0, $t5								#adds the hex value to the value of the origin to make sure it fits on the grid
	move $t5, $zero									#resets this temporary register to 0 so it can be used again later in the program
	addi $t5, $zero, -1								#subtracts one for the purposes of functioning within the iterator of the loop
	div $t6, $t1, 2									#sets a register to half the height, also used in the loop
	addi $t0, $t0, -512								#subtracts -512, or a row from the tip of the diamond regester, also for the sake of the way the loop is formatted
	forloop:
		addi $t0, $t0, 512							#iterates to a new row
		addi $t5, $t5, 1							#counter iteration
		beq $t5, $t1, exitdiamond						#exits if the number of rows drawn equals the height
		bge $t5, $t6, bottom							#enters the loop for the bottom if the counter is greater than or equal to half of the height
		top:
			mul $t7, $t5, 2							#multiplies the counter by two and assigns it to t7, used for deciding how many pixels to fill in
			addi $t7, $t7, 1						#adds one to the counter which determines how many pixels to fill in
			move $t8, $t0							#assigns the center of the diamond to a tempoarary register
			move $t3, $t5							#assigns the counter to a temporary register
			while:
				beq $t3, $zero, continue				#enters continue once the selected pixel is the correct distance away from the center
				addi $t8, $t8, -4					#moves back one pixel for each 
				addi $t3, $t3, -1					#decreased iterator by one for the sake of the loop
				j while							#reenters the loop	 
			continue:	  	
				beq $t7, 0, forloop					#goes to the top of the loop when the counter is equal to 0
				sw $t2, ($t8)						#assigns color to the designated register
				addi $t8, $t8, 4					#iterates to the next pixel
				addi $t7, $t7, -1					#subtracts one from the counter
				j continue						#jumps to continue
		bottom:
			sub $t9, $t1, $t5 						#subtracts the counter from the height, in a way giving us a new measure of distance to refer to
			mul $t7, $t9, 2							#multiplies the counter by two and assigns it to t7, used for deciding how many pixels to fill in
			addi $t7, $t7, 1						#adds one to the counter which determines how many pixels to fill in
			move $t8, $t0							#assigns the center of the diamond to a tempoarary register
			whileb:
				beq $t9, $zero, continueb				#enters continueb once the selected pixel is the correct distance away from the center
				addi $t8, $t8, -4					#moves back one pixel for each 
				addi $t9, $t9, -1					#decreased iterator by one for the sake of the loop 
				j whileb						#reenters the loop	 
			continueb:	  	
				beq $t7, 0, forloop					#goes to the top of the loop when the counter is equal to 0
				sw $t2, ($t8)						#assigns color to the designated register	
				addi $t8, $t8, 4					#iterates to the next pixel
				addi $t7, $t7, -1					#subtracts one from the counter
				j continueb						#jumps to continue
	exitdiamond:
		jr $ra									#jumps to where the function was called
	
