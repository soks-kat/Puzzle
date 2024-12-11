#!/bin/bash
yasm -f elf64 -g dwarf2 15puzzle_Basic.asm \
&& \
gcc -no-pie -mincoming-stack-boundary=3 -g -o puzzle 15puzzle_Basic.o 15puzzle_Basic.c \
&& \
./puzzle