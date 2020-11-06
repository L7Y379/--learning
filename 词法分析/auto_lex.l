/* recognize tokens for the calculator and print them out */
%{
enum yytokentype {
ABSTRACT=258,CASE,CATCH,CLASS,DEF,DO,ELSE,EXTENDS,FALSE1,FINAL,FINALLY,FOR,FORSOME,IF,IMPLICIT,IMPORT,LAZY,MACRO,MATCH,NEW,NULL1,OBJECT,OVERRIDE,PACKAGE,PRIVATE,PROTECTED,RETURN,SEALED,SUPER,THIS,THROW,TRAIT,TRY,TRUE1,TYPE,VAL,VAR,WHILE,WITH,YIELD,SOB1,SOB2,SOB3,SOB4,SOB5,SOB6,SOB7,SOB8,SOB9,SOB10,INT,ID,ADD,RBRA,LBRA,LPAR,RPAR,QUO,PUN,RSLA,RSUA,LSUA,LE,AND,ZHUSHI1,ZHUSHI2,ZIFUCHUAN};

int yylval;
%}

%%
([\n]|[\t]|[ ])* {}
[1-9][0-9]* {return INT;}
["]([^\n^"]|[\\]["])*[^\\]["] {return ZIFUCHUAN;}
[A-Za-z][A-Za-z0-9]* {return ID;}
\/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/ {return ZHUSHI1;}
\/\/[^\n]* {return ZHUSHI2;}
\_ { return SOB1; }
\: { return SOB2; }
\=	{ return SOB3; }
[=][>]	{ return SOB4; }
[<][-]	{ return SOB5; }
[<][:] { return SOB6; }
[<] { return SOB7; }
[>][:] { return SOB8; }
[#] { return SOB9; }
[@] { return SOB10; }
^abstract$ {return ABSTRACT;}
^case$ {return CASE;}
^catch$ {return CATCH;}
^class$ {return CLASS;}
^def$ {return DEF;}
^do$ {return DO;}
^else$ {return ELSE;}
^extends$ {return EXTENDS;}
^false$ {return FALSE1;}
^final$ {return FINAL;}
^for$ {return FOR;}
^finally$ {return FINALLY;}
^forSome$ {return FORSOME;}
^if$ {return IF;}
^implicit$ {return IMPLICIT;}
^import$ {return IMPORT;}
^lazy$ {return LAZY;}
^macro$ {return MACRO;}
^match$ {return MATCH;}
^new$ {return NEW;}
^null$ {return NULL1;}
^object$ {return OBJECT;}
^override$ {return OVERRIDE;}
^package$ {return PACKAGE;}
^private$ {return PRIVATE;}
^protected$ {return PROTECTED;}
^return$ {return RETURN;}
^sealed$ {return SEALED;}
^super$ {return SUPER;}
^this$ {return THIS;}
^throw$ {return THROW;}
^trait$ {return TRAIT;}
^try$ {return TRY;}
^true$ {return TRUE1;}
^type$ {return TYPE;}
^val$ {return VAL;}
^var$ {return VAR;}
^while$ {return WHILE;}
^with$ {return WITH;}
^yield$ {return YIELD;}
[+]	{return ADD;}
[{]	{return RBRA;}
[}]	{return LBRA;}
[(]	{return LPAR;}
[)]	{return RPAR;}
[.]	{return PUN;}
[\[] {return RSUA;}
[\]] {return LSUA;}
[<][=] {return LE;}
[&]	{return AND;}
%%


int main(int argc, char *argv[])
{ 
	if(argc<2){
		printf("ERROR:input file name is needed.\n");
		exit(0);
	}
	yyin=fopen(argv[1],"r"); 
	int tok;

	while(tok = yylex()) 
	{
		printf("%d,%s\n",tok,yytext);
		
	}
} 

int yywrap()
{
	return 1;
}
