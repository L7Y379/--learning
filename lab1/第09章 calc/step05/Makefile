# part of the makefile
default: calc.l calc.y calc.h
	bison -d calc.y
	flex calc.l
	gcc -o $@ calc.tab.c lex.yy.c calc.c -lfl -lm
