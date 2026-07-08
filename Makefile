all:
	flex lexer.l
	bison -d parser.y
	gcc -o interpreter main.c lex.yy.c parser.tab.c
	./interpreter < input.txt
# linia wyżej służy do pobieraniu kodu z pliku input.txt
