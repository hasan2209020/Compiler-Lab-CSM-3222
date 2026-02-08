all: parser

parser: parser.tab.c lex.yy.c
	gcc lex.yy.c parser.tab.c -o parser -lm

parser.tab.c parser.tab.h: parser.y
	bison -d parser.y

lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

clean:
	rm -f parser parser.exe lex.yy.c parser.tab.c parser.tab.h
