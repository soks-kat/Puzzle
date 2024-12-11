#!/bin/bash
yasm -f elf64 -g dwarf2 15puzzle_Mig.asm \
&& \
gcc -no-pie -mincoming-stack-boundary=3 -g -o puzzle 15puzzle_Mig.o 15puzzle_Mig.c \
&& \
./puzzle