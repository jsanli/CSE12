John Sanli 

jsanli

Fall 2020

Lab 2: 
A data path is the path by which data flows in a system. In this lab, you will implement a simple data path with a register file, ALU, and user inputs.
Each processor contains a register file that holds the registers used in program execution. Registers are fast access local variables that can change after every instruction.
In this lab, you will be building a register file that contains four, 4-bit registers. Each of the four registers has an address (0b00 -> 0b11) and stores a 4-bit value.
The value saved to a destination register (write register) will be chosen from one of two sources, the keypad user input, or the output of the ALU. The ALU in this system is a 4-bit bitwise left arithmetic shift circuit that takes two of the register values as inputs (read registers). You may not use the MML library ALU and should instead build one out of muxes or logic gates.
From the user interface, the user will select the data source (source select) and the addresses of the read and write registers.

Open in Multimedia Logic and Press the Play Button to Run. Interact with the input areas on the first page to cause circuits to execute.