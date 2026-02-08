%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int tempCount=1;
int regCount=0;

char asmBuffer[10000] = "";
int asmBufferPos = 0;

void appendASM(const char* format, ...) {
  va_list args;
  va_start(args, format);
  asmBufferPos += vsprintf(asmBuffer + asmBufferPos, format, args);
  va_end(args);
}

#include <stdarg.h>

char* newTemp(){
char *t=(char*)malloc(10);
sprintf(t,"t%d",tempCount++);
return t;
}

char* newReg(){
char *r=(char*)malloc(10);
sprintf(r,"R%d",regCount++);
return r;
}

void emitBinary(char* op,char* a1,char* a2,char* res){
char *r=newReg();

appendASM("MOV %s , %s\n",r,a1);

if(!strcmp(op,"+")) appendASM("ADD %s , %s\n",r,a2);
else if(!strcmp(op,"-")) appendASM("SUB %s , %s\n",r,a2);
else if(!strcmp(op,"*")) appendASM("MUL %s , %s\n",r,a2);
else if(!strcmp(op,"/")) appendASM("DIV %s , %s\n",r,a2);
else if(!strcmp(op,"%")) appendASM("MOD %s , %s\n",r,a2);

appendASM("MOV %s , %s\n",res,r);
}

void emitFunc1(char* fname,char* arg,char* res){
char *r=newReg();

appendASM("MOV %s , %s\n",r,arg);

if(!strcmp(fname,"sqrt")) appendASM("SQRT %s\n",r);
else if(!strcmp(fname,"log")) appendASM("LOG %s\n",r);
else if(!strcmp(fname,"exp")) appendASM("EXP %s\n",r);
else if(!strcmp(fname,"sin")) appendASM("SIN %s\n",r);
else if(!strcmp(fname,"cos")) appendASM("COS %s\n",r);
else if(!strcmp(fname,"tan")) appendASM("TAN %s\n",r);
else if(!strcmp(fname,"abs")) appendASM("ABS %s\n",r);

appendASM("MOV %s , %s\n",res,r);
}

void emitPow(char* a1,char* a2,char* res){
char *r=newReg();

appendASM("MOV %s , %s\n",r,a1);
appendASM("POW %s , %s\n",r,a2);
appendASM("MOV %s , %s\n",res,r);
}

void yyerror(const char *s){
  fprintf(stderr, "Error: %s\n", s);
}
int yylex();
extern FILE *yyin;
%}

%union{
char* str;
}

%token <str> ID NUM
%token SQRT POWF LOGF EXPF SINF COSF TANF ABSF

%type <str> E T F

%%

Program:
Program Stmt
| Stmt
;

Stmt:
ID '=' E '\n'
{
printf("%s = %s\n",$1,$3);
printf("MOV %s , %s\n",$1,$3);
regCount=0;
}
| error '\n'
{
  printf("Recovered from parse error\n");
  yyclearin;
}
;

E:
E '+' T
{
char *t=newTemp();
printf("%s = %s + %s\n",t,$1,$3);
emitBinary("+",$1,$3,t);
$$=t;
}
| E '-' T
{
char *t=newTemp();
printf("%s = %s - %s\n",t,$1,$3);
emitBinary("-",$1,$3,t);
$$=t;
}
| T { $$=$1; }
;

T:
T '*' F
{
char *t=newTemp();
printf("%s = %s * %s\n",t,$1,$3);
emitBinary("*",$1,$3,t);
$$=t;
}
| T '/' F
{
char *t=newTemp();
printf("%s = %s / %s\n",t,$1,$3);
emitBinary("/",$1,$3,t);
$$=t;
}
| T '%' F
{
char *t=newTemp();
printf("%s = %s %% %s\n",t,$1,$3);
emitBinary("%",$1,$3,t);
$$=t;
}
| F { $$=$1; }
;

F:
SQRT '(' E ')'
{
char *t=newTemp();
printf("%s = sqrt ( %s )\n",t,$3);
emitFunc1("sqrt",$3,t);
$$=t;
}
| LOGF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = log ( %s )\n",t,$3);
      emitFunc1("log",$3,t);
      $$=t;
  }

| EXPF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = exp ( %s )\n",t,$3);
      emitFunc1("exp",$3,t);
      $$=t;
  }

| SINF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = sin ( %s )\n",t,$3);
      emitFunc1("sin",$3,t);
      $$=t;
  }

| COSF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = cos ( %s )\n",t,$3);
      emitFunc1("cos",$3,t);
      $$=t;
  }

| TANF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = tan ( %s )\n",t,$3);
      emitFunc1("tan",$3,t);
      $$=t;
  }

| ABSF '(' E ')'
  {
      char *t=newTemp();
      printf("%s = abs ( %s )\n",t,$3);
      emitFunc1("abs",$3,t);
      $$=t;
  }

| POWF '(' E ',' E ')'
  {
      char *t=newTemp();
      printf("%s = pow ( %s , %s )\n",t,$3,$5);
      emitPow($3,$5,t);
      $$=t;
  }

| '-' F
  {
      char *t=newTemp();
      printf("%s = - %s\n",t,$2);

      char *r=newReg();
      printf("MOV %s , %s\n",r,$2);
      printf("NEG %s\n",r);
      printf("MOV %s , %s\n",t,r);

      $$=t;
  }

| '(' E ')'
  { $$=$2; }

| ID  { $$=$1; }
| NUM { $$=$1; }
;

%%