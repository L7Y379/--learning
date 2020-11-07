/* simplest version of calculator */
%{
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include "calc.h"
%}

%union {
	struct ast *a;
	double d;
}

/* declare tokens */
/* declare tokens */
%token <d> NUMBER
%type <a> exp factor term

%token ADD SUB MUL DIV ABS LP RP
%token EOL

%%

calclist: /* nothing */
	| calclist exp EOL { printf("= %4.4g\n", eval($2)); 
						 treefree($2);
						 printf("> ");} 
	| calclist EOL { printf("> "); }
	;
exp: factor
	| exp '+' factor { $$ = newast('+', $1, $3); }
	| exp '-' factor { $$ = newast('-', $1, $3); }
	;
factor: term
	| factor '*' term { $$ = newast('*', $1, $3); }
	| factor '/' term { $$ = newast('/', $1, $3); }
	;
term: NUMBER	{$$ = newnum($1);}
	| '|' term	{ $$ = newast('|', $2, NULL); }
	| '(' exp ')' { $$ = $2; }
	| '-' exp	{ $$ = newast('M', $2, NULL); }
	;

%%

int
main()
{
	printf("> ");
	return yyparse();
}


void
yyerror(char *s, ...)
{
	va_list ap;
	va_start(ap, s);
	fprintf(stderr, "%d: error: ", yylineno);
	vfprintf(stderr, s, ap);
	fprintf(stderr, "\n");
}

