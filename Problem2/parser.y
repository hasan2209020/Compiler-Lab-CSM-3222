%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
int yylex();
int yyerror(const char* s);

int tempCount = 1;

char* newTemp() {
    char buffer[10];
    sprintf(buffer, "t%d", tempCount++);
    return strdup(buffer);
}

void emit(char* s) {
    printf("%s\n", s);
}
%}

%union {
    char* str;
}

%token <str> ID NUM
%token SQRT POW LOG EXP SIN COS TAN ABS
%token NEWLINE

%type <str> Expression Term Factor FunctionCall Statement

%%
Program:
      StatementList
    | StatementList NEWLINE
    | NEWLINE
    ;

StatementList:
      Statement
    | StatementList NEWLINE Statement
    ;

Statement:
      ID '=' Expression {
          char buf[100];
          sprintf(buf, "%s = %s", $1, $3);
          emit(buf);
      }
    | /* empty */ { /* allow empty statements */ }
    ;

Expression:
      Expression '+' Term {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = %s + %s", t, $1, $3);
          emit(buf);
          $$ = t;
      }
    | Expression '-' Term {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = %s - %s", t, $1, $3);
          emit(buf);
          $$ = t;
      }
    | Term { $$ = $1; }
    ;

Term:
      Term '*' Factor {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = %s * %s", t, $1, $3);
          emit(buf);
          $$ = t;
      }
    | Term '/' Factor {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = %s / %s", t, $1, $3);
          emit(buf);
          $$ = t;
      }
    | Term '%' Factor {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = %s %% %s", t, $1, $3);
          emit(buf);
          $$ = t;
      }
    | Factor { $$ = $1; }
    ;

Factor:
      '(' Expression ')' { $$ = $2; }
    | '-' Factor {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = -%s", t, $2);
          emit(buf);
          $$ = t;
      }
    | FunctionCall { $$ = $1; }
    | ID { $$ = $1; }
    | NUM { $$ = $1; }
    ;

FunctionCall:
      SQRT '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = sqrt(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | POW '(' Expression ',' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = pow(%s,%s)", t, $3, $5);
          emit(buf);
          $$ = t;
      }
    | LOG '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = log(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | EXP '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = exp(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | SIN '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = sin(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | COS '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = cos(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | TAN '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = tan(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    | ABS '(' Expression ')' {
          char* t = newTemp();
          char buf[100];
          sprintf(buf, "%s = abs(%s)", t, $3);
          emit(buf);
          $$ = t;
      }
    ;

%%

int yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main() {
    FILE* file = fopen("input.txt", "r");
    if (!file) {
        fprintf(stderr, "Error: Cannot open input.txt\n");
        return 1;
    }
    yyin = file;
    yyparse();
    fclose(file);
    return 0;
}
