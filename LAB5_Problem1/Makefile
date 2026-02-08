.PHONY: all clean run

all: parser

parser: lex.yy.c parser.tab.c
	gcc lex.yy.c parser.tab.c -o parser

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

run: parser
	.\parser

clean:
	del /q parser.exe lex.yy.c parser.tab.c parser.tab.h 2>nul || true
