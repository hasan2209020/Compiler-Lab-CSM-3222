%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
%}

ID      [a-zA-Z][a-zA-Z0-9]*
NUM     [0-9]+

%%

"**"        return POW;
"//"        return IDIV;
"&&"        return AND;
"||"        return OR;
"!"         return NOT;

"//="       return IDIV_ASSIGN;
"+="        return ADD_ASSIGN;
"-="        return SUB_ASSIGN;
"*="        return MUL_ASSIGN;
"/="        return DIV_ASSIGN;
"%="        return MOD_ASSIGN;
"**="       return POW_ASSIGN;

">"         return GT;
"<"         return LT;

"+"         return '+';
"-"         return '-';
"*"         return '*';
"/"         return '/';
"%"         return '%';
"="         return '=';

"("         return '(';
")"         return ')';

{ID} {
    yylval.str = strdup(yytext);
    return ID;
}

{NUM} {
    yylval.str = strdup(yytext);
    return NUM;
}

[ \t]       ;
\n          return '\n';

.           ;

%%

int yywrap() {
    return 1;
}
