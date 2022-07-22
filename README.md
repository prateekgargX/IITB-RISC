# IITB-RISC
The IITB-RISC is an 8-register, 16-bit computer system. 

It has 8 general-purpose registers (R0 to R7). Register R7 always stores Program Counter. 

All addresses are short word addresses (i.e., address 0 corresponds to the first two bytes of main memory, address 1 corresponds to the second two bytes of main memory, etc.). 

This architecture uses condition code register which has two flags Carry flag (C) and Zero flag (Z). 

The IITB-RISC is very simple, but it is general enough to solve complex problems. 

The architecture allows predicated instruction execution and multiple load and store execution. There are three machine-code instruction formats (R, I, and J type) and a total of 17 instructions.
