%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%
"sqrt"      return SQRT;
"pow"       return POW;
"log"       return LOG;
"exp"       return EXP;
"sin"       return SIN;
"cos"       return COS;
"tan"       return TAN;
"abs"       return ABS;

[a-zA-Z][a-zA-Z0-9]* {
    yylval.str = strdup(yytext);
    return ID;
}

[0-9]+ {
    yylval.str = strdup(yytext);
    return NUM;
}

"="     return '=';
"+"     return '+';
"-"     return '-';
"*"     return '*';
"/"     return '/';
"%"     return '%';
"("     return '(';
")"     return ')';
","     return ',';
"\n"    return NEWLINE;

[ \t]+  ;
.       ;

%%
