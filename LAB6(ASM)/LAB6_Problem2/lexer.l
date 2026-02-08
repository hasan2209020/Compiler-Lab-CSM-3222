%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

ID      [a-zA-Z][a-zA-Z0-9]*
NUM     [0-9]+

%%

"sqrt"     return SQRT;
"pow"      return POWF;
"log"      return LOGF;
"exp"      return EXPF;
"sin"      return SINF;
"cos"      return COSF;
"tan"      return TANF;
"abs"      return ABSF;

"+"        return '+';
"-"        return '-';
"*"        return '*';
"/"        return '/';
"%"        return '%';
"="        return '=';

"("        return '(';
")"        return ')';
","        return ',';

{ID} {
yylval.str = strdup(yytext);
return ID;
}

{NUM} {
yylval.str = strdup(yytext);
return NUM;
}

[ \t]   ;
\n      return '\n';

. ;

%%

int yywrap(){
return 1;
}

int yyparse();
extern char asmBuffer[];

int main(){
  FILE *fp = fopen("input.txt", "r");
  if (!fp) {
    fprintf(stderr, "Error: Cannot open input.txt\n");
    return 1;
  }
  
  yyin = fp;
  
  int result = yyparse();
  
  fclose(fp);
  
  printf("%s", asmBuffer);
  
  return result;
}