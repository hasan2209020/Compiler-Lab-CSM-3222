LEX = flex
YACC = bison
CC = gcc
CFLAGS = -g -w

TARGET = parser

all: $(TARGET)

parser.tab.c parser.tab.h: parser.y
	$(YACC) -d parser.y

lex.yy.c: lexer.l parser.tab.h
	$(LEX) lexer.l

$(TARGET): parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) parser.tab.c lex.yy.c -o $(TARGET) -lm

run: $(TARGET)
	parser.exe < input.txt

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c *.o

.PHONY: all run clean
