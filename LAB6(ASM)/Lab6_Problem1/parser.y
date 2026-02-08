%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount = 1;
int regCount  = 0;
int firstOutput = 1;

FILE *tac_file;
FILE *asm_file;

char* newTemp() {
    char *t = (char*)malloc(10);
    sprintf(t,"t%d",tempCount++);
    return t;
}

char* newReg() {
    char *r = (char*)malloc(10);
    sprintf(r,"R%d",regCount++);
    return r;
}

/* Assembly emitter */
void emitAsm(char* op,char* a1,char* a2,char* res) {

    char *r = newReg();

    fprintf(asm_file, "    MOV %s , %s\n", r, a1);

    if(!strcmp(op,"+"))   fprintf(asm_file, "    ADD %s , %s\n", r,a2);
    else if(!strcmp(op,"-")) fprintf(asm_file, "    SUB %s , %s\n", r,a2);
    else if(!strcmp(op,"*")) fprintf(asm_file, "    MUL %s , %s\n", r,a2);
    else if(!strcmp(op,"/")) fprintf(asm_file, "    DIV %s , %s\n", r,a2);
    else if(!strcmp(op,"%")) fprintf(asm_file, "    MOD %s , %s\n", r,a2);
    else if(!strcmp(op,"**")) fprintf(asm_file, "    POW %s , %s\n", r,a2);
    else if(!strcmp(op,"//")) fprintf(asm_file, "    IDIV %s , %s\n", r,a2);
    else if(!strcmp(op,"&&")) fprintf(asm_file, "    AND %s , %s\n", r,a2);
    else if(!strcmp(op,"||")) fprintf(asm_file, "    OR %s , %s\n", r,a2);
    else if(!strcmp(op,">")) fprintf(asm_file, "    CMPGT %s , %s\n", r,a2);
    else if(!strcmp(op,"<")) fprintf(asm_file, "    CMPLT %s , %s\n", r,a2);

    fprintf(asm_file, "    MOV %s , %s\n", res, r);
}

void yyerror(const char *s){
    fprintf(stderr, "Error: %s\n", s);
}

int yylex();
%}

%union {
    char* str;
}

%token <str> ID NUM
%token ADD_ASSIGN SUB_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN IDIV_ASSIGN POW_ASSIGN
%token POW IDIV AND OR NOT GT LT

%type <str> E T F U

%%

Program:
      Program Stmt
    | Program '\n'
    | Stmt
    | /* empty */
    ;

Stmt:
      ID '=' E '\n'
      {
          fprintf(tac_file, "%s = %s\n",$1,$3);
          fprintf(asm_file, "MOV %s , %s\n",$1,$3);
          regCount=0;
      }

    | ID ADD_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s + %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("+",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID SUB_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s - %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("-",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID MUL_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s * %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("*",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID DIV_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s / %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("/",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID MOD_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s %% %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("%",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID IDIV_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s // %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("//",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }

    | ID POW_ASSIGN E '\n'
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s ** %s\n",t,$1,$3);
          fprintf(tac_file, "%s = %s\n",$1,t);
          emitAsm("**",$1,$3,t);
          fprintf(asm_file, "MOV %s , %s\n",$1,t);
          regCount=0;
      }
    ;

E:
      E '+' T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s + %s\n",t,$1,$3);
          emitAsm("+",$1,$3,t);
          $$=t;
      }

    | E '-' T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s - %s\n",t,$1,$3);
          emitAsm("-",$1,$3,t);
          $$=t;
      }

    | E AND T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s && %s\n",t,$1,$3);
          emitAsm("&&",$1,$3,t);
          $$=t;
      }

    | E OR T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s || %s\n",t,$1,$3);
          emitAsm("||",$1,$3,t);
          $$=t;
      }

    | E GT T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s > %s\n",t,$1,$3);
          emitAsm(">",$1,$3,t);
          $$=t;
      }

    | E LT T
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s < %s\n",t,$1,$3);
          emitAsm("<",$1,$3,t);
          $$=t;
      }

    | T { $$=$1; }
    ;

T:
      T '*' F
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s * %s\n",t,$1,$3);
          emitAsm("*",$1,$3,t);
          $$=t;
      }

    | T '/' F
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s / %s\n",t,$1,$3);
          emitAsm("/",$1,$3,t);
          $$=t;
      }

    | T '%' F
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s %% %s\n",t,$1,$3);
          emitAsm("%",$1,$3,t);
          $$=t;
      }

    | T IDIV F
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s // %s\n",t,$1,$3);
          emitAsm("//",$1,$3,t);
          $$=t;
      }

    | F { $$=$1; }
    ;

F:
      F POW U
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = %s ** %s\n",t,$1,$3);
          emitAsm("**",$1,$3,t);
          $$=t;
      }

    | U { $$=$1; }
    ;

U:
      NOT U
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = ! %s\n",t,$2);

          char *r=newReg();
          fprintf(asm_file, "    MOV %s , %s\n",r,$2);
          fprintf(asm_file, "    NOT %s\n",r);
          fprintf(asm_file, "    MOV %s , %s\n",t,r);

          $$=t;
      }

    | '-' U
      {
          char *t=newTemp();
          fprintf(tac_file, "%s = - %s\n",t,$2);

          char *r=newReg();
          fprintf(asm_file, "    MOV %s , %s\n",r,$2);
          fprintf(asm_file, "    NEG %s\n",r);
          fprintf(asm_file, "    MOV %s , %s\n",t,r);

          $$=t;
      }

    | '(' E ')'
      { $$=$2; }

    | ID { $$=$1; }
    | NUM { $$=$1; }
    ;

%%

int main(){
    int c;
    char line[1024];
    
    tac_file = fopen("tac_temp.txt", "w");
    asm_file = fopen("asm_temp.txt", "w");
    
    yyparse();
    
    fclose(tac_file);
    fclose(asm_file);
    
    printf("=== THREE ADDRESS CODE ===\n\n");
    tac_file = fopen("tac_temp.txt", "r");
    if(tac_file) {
        while(fgets(line, sizeof(line), tac_file)) {
            printf("%s", line);
        }
        fclose(tac_file);
    }
    
    printf("\n=== ASSEMBLY CODE ===\n\n");
    asm_file = fopen("asm_temp.txt", "r");
    if(asm_file) {
        while(fgets(line, sizeof(line), asm_file)) {
            printf("%s", line);
        }
        fclose(asm_file);
    }
    
    remove("tac_temp.txt");
    remove("asm_temp.txt");
    
    return 0;
}
