# About the Project 
Devised a cycle-accurate dual-issue 11-stage pipelined model of a Cell SPU lite processing core and defined an
instruction set comprising 90 assembly instructions. Created the model of the processing core, which includes fetch modules, decode modules,
data forwarding circuits, two pipes with multiple pipelined processing units, local memory and verified through a key 4x4 matrix multiplication test in assembly language. Implemented hazard detection and mitigation techniques for data, control, and structural hazards in the design. Composed a parser algorithm to convert assembly code to binary code for input to the Super scalar processor core.

The complete Report is also attached for a complete understanding of the project.

# Instructions to Run
The input assembly code is converted into binary using make command. Makefile can be seen in parser directory. Compiling and Simulation can be done with standard vlog and vsim commands.
Output can be verified by looking at local store memory in waveforms for the case of matrix multiplication.
