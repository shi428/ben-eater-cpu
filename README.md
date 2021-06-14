# SystemVerilog Implementation of the Ben Eater 8-bit Breadboard Computer

Since building this project can be very tedious on a breadboard. I decided to implement Ben Eater's 8-bit computer in SystemVerilog. For those who are interested in a detailed tutorial, please refer to the following [playlist](https://www.youtube.com/watch?v=HyznrdDSSGM&list=PLowKtXNTBypGqImE405J2565dvjafglHU)

## Instruction set architecture

The instruction set architecture for the CPU is exactly the same as the instruction set that is used in ben eater's videos. The first four bits contain the opcode, and the second four bits either contain an immediate value or an address.

The description of the opcodes are as follows:
* 4'b0001: LDA - Loads the 8-bit value that resides at the 4-bit address in the lower 4 bits of the instruction into the A register.
* 4'b0010: ADD - Loads the 8-bit value that resides at the 4-bit address in the lower 4 bits of the instruction into the B register, and adds it to the value stored in the A register. The result is then stored back into the A register.
* 4'b0011: SUB - Same procedure as ADD, except the ALU subtracts instead.
* 4'b0100: STA - Stores the 8-bit value present in the A register at the memory address specified by the lower 4 bits of the instruction.
* 4'b0101: LDI - Loads the 4-bit immediate value specified by the lower 4 bits of the instruction into the A register.
* 4'b0110: JMP - Jumps to a certain instruction by loading the instruction address specified by the lower 4 bits of the instruction into the program counter.
* 4'b1110: OUT - outputs the 8-bit value in the A register onto the 7-segment display.
* 4'b1111: HALT - halts execution of the processor.
* 4'b0111: JC - Does the same thing as jump except only when the carry flag is set.
* 4'b1000: JZ - Conditional jump when the zero flag is set.

## Repository Overview
* The ```design``` directory contains an rtl diagram describing the entire design for the computer.
* The ```include``` directory contains SystemVerilog code for interfaces used within the design.
* The ```programs``` directory contains sample programs that can be run on the computer.
* The ```scripts``` directory contains scripts used for Makefile execution.
* The ```source``` directory contains 2 sub-directories ```constraints``` and ```modules```. The ```constraints``` directory contains the pin information for an Altera DE2-115 Development board, and the ```modules``` directory contains all of the SystemVerilog code for the computer.
* The ```testbench``` directory contains non-synthesizable SystemVerilog code for design verification.

## How to build this project
In order to fully realize the results of this computer. The following hardware and software is required: an Altera DE2-115 Development board, and Quartus II software with ModelSim.

To build and simulate this project, type ```make cpu.sim```. This will run the cpu testbench located at ```testbench/cpu_tb.sv```, which contains the Fibonacci program. The testbench will then dump all the output values at each clock cycle. A development board is not required to run this command.

To synthesize the design, type ```make cpu.syn```, and to program the fpga, type ```make cpu.synd```. The computer is now ready to be programmed.

To program the computer, toggle SW16 to enter programming mode. This will light up LED16 and will allow you to enter data at certain memory addresses. Memory addresses are indexed by SW11 - SW8 and each byte is then specified by SW7 - SW0. Once the data is entered at a certain address toggle KEY2 to write to that address. Once the computer is fully programmed, turn off SW16 to allow the computer to enter run mode. Within run mode, you can either choose to manually advance the clock by toggling SW17 to switch to manual clock mode, and signalling clock pulses by pressing KEY1. You can also toggle SW15-SW0 to change the clock speed (automatic mode only). The larger the value, the slower the clock will run. This will make it easier to see what is going on in a program. You can also reset the computer by pressing KEY0.
