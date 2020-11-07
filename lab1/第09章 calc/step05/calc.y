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
	struct symbol *s;	//which symbol
	struct symlist *sl;
	int fn;				//which function
}


/* declare tokens */
%token <d> NUMBER
%token <s> NAME
%token <fn> FUNC
%token EOL
%token IF THEN ELSE WHILE DO LET

%nonassoc <fn> CMP
%right '='
%left '+' '-'
%left '*' '/'
%nonassoc '|' UMINUS
%type <a> exp stmt list explist
%type <sl> symlist

//A %start declaration identifies the top-level rule, so we don¡¯t have to put it at the beginning of the parser.
%start calclist


/*
Each of these declarations defines a level of precedence, with the order of the %left ,
%right , and %nonassoc declarations defining the order of precedence from lowest to
highest. They tell bison that + and - are left associative and at the lowest precedence
level; * and / are left associative and at a higher precedence level; and | and UMINUS , a
pseudotoken standing for unary minus, have no associativity and are at the highest
precedence.

The token CMP is any of the six comparison operators, with the value indicating which operator. 
(This trick of using one token for several syntactically similar operators helps keep down the size of the grammar.)
*/

%%

calclist: /* nothing */
	| calclist stmt EOL {
					printf("= %4.4g\n> ", eval($2));
					treefree($2);
				}
	| calclist LET NAME '(' symlist ')' '=' list EOL {
						dodef($3, $5, $8);
						printf("Defined %s\n> ", $3->name); 
						}
	| calclist error EOL { yyerrok; printf("> "); }
	;


stmt: IF exp THEN list				{ $$ = newflow('I', $2, $4, NULL); }
	| IF exp THEN list ELSE list	{ $$ = newflow('I', $2, $4, $6); }
	| WHILE exp DO list				{ $$ = newflow('W', $2, $4, NULL); }
	| exp
	;


list: /* nothing */ { $$ = NULL; }
	| stmt ';' list { if ($3 == NULL)
						$$ = $1;
					  else
						$$ = newast('L', $1, $3);
					}
	;
	
	
exp:	exp CMP exp				{$$ = newcmp($2, $1, $3); }
	|	exp '+' exp				{$$ = newast('+', $1,$3); }
	|	exp '-' exp				{$$ = newast('-', $1,$3); }
	|	exp '*' exp				{$$ = newast('*', $1,$3); }
	|	exp '/' exp				{$$ = newast('/', $1,$3); }
	|	'|' exp					{$$ = newast('|', $2,NULL); }
	|	'(' exp ')'				{$$ = $2;}
	|	'-' exp %prec UMINUS	{$$ = newast('M', $2,NULL); }
	|	NUMBER					{$$ = newnum($1); }
	|	NAME					{$$ = newref($1); }
	|	NAME '=' exp			{$$ = newasgn($1, $3); }
	|	FUNC '(' explist ')'	{$$ = newfunc($1, $3); }
	|	NAME '(' explist ')'	{$$ = newcall($1, $3); }


explist: exp
	| exp ',' explist { $$ = newast('L', $1, $3); }
	;
symlist: NAME	{ $$ = newsymlist($1, NULL); }
	| NAME ',' symlist { $$ = newsymlist($1, $3); }
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

