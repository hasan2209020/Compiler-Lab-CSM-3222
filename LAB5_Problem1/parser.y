%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern FILE* yyin;
int yyerror(const char *s);

int tempCount = 1;

char* newTemp() {
    char* t = (char*)malloc(10);
    sprintf(t, "t%d", tempCount++);
    return t;
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN POW_ASSIGN IDIV_ASSIGN
%token PLUS MINUS MUL DIV MOD POW IDIV ASSIGN
%token NOT OR AND GT LT
%token LPAREN RPAREN
%token NEWLINE

%type <str> expr term factor unary primary

/* Operator precedence */
%left OR
%left AND
%left GT LT
%left PLUS MINUS
%left MUL DIV MOD IDIV
%right POW
%right NOT

%%

program:
      program stmt
    | stmt
    ;

stmt:
      ID ASSIGN expr NEWLINE {
          printf("%s = %s\n", $1, $3);
      }
    | ID ADD_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s + %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID SUB_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s - %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID MUL_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s * %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID DIV_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s / %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID MOD_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s %% %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID POW_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s ** %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | ID IDIV_ASSIGN expr NEWLINE {
          char* t = newTemp();
          printf("%s = %s // %s\n", t, $1, $3);
          printf("%s = %s\n", $1, t);
      }
    | NEWLINE { /* skip empty lines */ }
    ;

expr:
      expr OR term {
          char* t = newTemp();
          printf("%s = %s || %s\n", t, $1, $3);
          $$ = t;
      }
    | expr AND term {
          char* t = newTemp();
          printf("%s = %s && %s\n", t, $1, $3);
          $$ = t;
      }
    | term { $$ = $1; }
    ;

term:
      term GT factor {
          char* t = newTemp();
          printf("%s = %s > %s\n", t, $1, $3);
          $$ = t;
      }
    | term LT factor {
          char* t = newTemp();
          printf("%s = %s < %s\n", t, $1, $3);
          $$ = t;
      }
    | term PLUS factor {
          char* t = newTemp();
          printf("%s = %s + %s\n", t, $1, $3);
          $$ = t;
      }
    | term MINUS factor {
          char* t = newTemp();
          printf("%s = %s - %s\n", t, $1, $3);
          $$ = t;
      }
    | factor { $$ = $1; }
    ;

factor:
      factor MUL unary {
          char* t = newTemp();
          printf("%s = %s * %s\n", t, $1, $3);
          $$ = t;
      }
    | factor DIV unary {
          char* t = newTemp();
          printf("%s = %s / %s\n", t, $1, $3);
          $$ = t;
      }
    | factor MOD unary {
          char* t = newTemp();
          printf("%s = %s %% %s\n", t, $1, $3);
          $$ = t;
      }
    | factor IDIV unary {
          char* t = newTemp();
          printf("%s = %s // %s\n", t, $1, $3);
          $$ = t;
      }
    | factor POW unary {
          char* t = newTemp();
          printf("%s = %s ** %s\n", t, $1, $3);
          $$ = t;
      }
    | unary { $$ = $1; }
    ;

unary:
      NOT unary {
          char* t = newTemp();
          printf("%s = ! %s\n", t, $2);
          $$ = t;
      }
    | primary { $$ = $1; }
    ;

primary:
      LPAREN expr RPAREN { $$ = $2; }
    | ID { $$ = $1; }
    | NUM { $$ = $1; }
    ;

%%

int main() {
    FILE *file = fopen("input.txt", "r");
    if (!file) {
        fprintf(stderr, "Error: Could not open input.txt\n");
        return 1;
    }
    yyin = file;
    yyparse();
    fclose(file);
    return 0;
}

int yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
    return 0;
}