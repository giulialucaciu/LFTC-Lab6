%{
#include <stdio.h>
#include <stdlib.h>
#define YYDEBUG 1

#define TIP_INT 1
#define TIP_REAL 2
#define TIP_CAR 3

double stiva[20];
int sp;

void push(double x)
{ stiva[sp++]=x; }

double pop()
{ return stiva[--sp]; }

%}

%union {
  	int l_val;
	char *p_val;
}

%token BEGINN
%token CONST
%token DO
%token ELSE
%token END
%token IF
%token PRINT
%token PROGRAM
%token READ
%token THEN
%token VAR
%token WHILE
%token CIN
%token COUT
%token FOR
%token CLASS
%token INT
%token LIST

%token ID
%token <p_val> CONST_INT
%token <p_val> CONST_REAL
%token <p_val> CONST_CAR
%token CONST_SIR

%token CHAR
%token INTEGER
%token REAL
%token BOOL
%token FLOAT
%token MAIN

%token ATRIB
%token NE
%token LE
%token GE

%left '+' '-'
%left DIV MOD '*' '/'
%left OR
%left AND
%left NOT


%%

program:			INT MAIN '(' ')' '{' declaration_list statement_list '}'	
			;
declaration_list:	declaration ';'
			|
			declaration ';' declaration_list
			;	
declaration:		type ID ';'
			|
			type ID ',' ID ';'
			;
type:			BOOL
			|
			FLOAT
			|
			CHAR
			|
			CONST_SIR
			;
arraydecl:		type ID '[' ']' '=' '{' '}' ';'
			|
			type ID '[' {CONST_INT} ']' '=' LIST ';'
			;
statement_list:		statement
			|
			statement ';' statement
			;
statement:		simple_statement ';'
			|
			input_output_statement ';'
			;
simple_statement:	assignment ';'
			|
			input_output_statement ';'
			;
compound_statement:	if_statement
			|
			while_statement
			;
assignment:		ID '=' expression ';'
			;
expression:		expression '+' term ';' 
			|
			term ';'
			;
term:			term '*'factor ';'
			|
			factor ';'
			;
factor:			'(' expression ')' ';'
			|
			ID ';'
			;
input_output_statement:	CIN '>' '>' input ';'
			|
			COUT '<' '<' output ';'
			;
input:			CONST_SIR
			|
			CONST_INT
			;
output:			CONST_SIR
			|
			CONST_INT
			;
if_statement:		IF '(' condition ')' '{' statement_list '}'
			|
			ELSE '{' statement_list '}'
			;
while_statement:		WHILE '(' condition ')' '{' statement_list '}'
			|
			ELSE '{' statement_list '}'
			;
condition:		expression relation expression
			|
			ID relation ID ':'
			| 
			ID relation CONST_INT ';'
			;
relation:		"<" 
			|
			"<="
			|
			">="
			|
			">"
			|
			"="
			|
			"=="
			|
			"<>"
			;		



%%

void yyerror(char *s)
{
  printf("%s\n", s);
}

extern FILE *yyin;



main(int argc, char **argv)
{
  if(argc>1) yyin = fopen(argv[1], "r");
  if((argc>2)&&(!strcmp(argv[2],"-d"))) yydebug = 1;
  if(!yyparse()) fprintf(stderr,"\tO.K.\n");
}