%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int yywrap(void) {
    return 1;
}
%}

%%

"**="       { return POW_ASSIGN; }
"//="       { return IDIV_ASSIGN; }
"%="        { return MOD_ASSIGN; }
"+="        { return ADD_ASSIGN; }
"-="        { return SUB_ASSIGN; }
"*="        { return MUL_ASSIGN; }
"/="        { return DIV_ASSIGN; }

"||"        { return OR; }
"&&"        { return AND; }
"**"        { return POW; }
"//"        { return IDIV; }

"!"         { return NOT; }
">"         { return GT; }
"<"         { return LT; }

"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"%"         { return MOD; }
"="         { return ASSIGN; }

"("         { return LPAREN; }
")"         { return RPAREN; }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return ID; }
[0-9]+                 { yylval.str = strdup(yytext); return NUM; }

\n          { return NEWLINE; }
[ \t]+      { /* ignore whitespace */ }
.           { /* ignore unknown characters */ }

%%
