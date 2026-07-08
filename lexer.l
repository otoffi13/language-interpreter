%{
    #include <string.h>
    #include <stdio.h>
    #include "parser.tab.h"
%}

%x COMMENT

%%
"```"        { BEGIN(COMMENT);} // początek komentarza wielolinijkowego

<COMMENT>{
    "```"    { BEGIN(INITIAL);} // koniec komentarza wielolinijkowego
    .     { /* ignoruj wszystko w komentarzu */ }
    \n     { yylineno++; }
}

"--".*        { /* ignoruj komentarz jednolinijkowy */ }



"wyswietl"      { return PRINT; }
"pobierz"       { return INPUT; }
"&&"            { return AND; }
"||"            { return OR; }
"~"             { return NOT; }

"<-"            { return ASSIGN; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MULTIPLY; }
"/"             { return DIVIDE; }
"=="            { return EQUAL; }
"!="            { return NOTEQUAL; }
"<"             { return LESS; }
"<="            { return LESS_EQUAL; }
">"             { return GREATER; }
">="            { return GREATER_EQUAL; }

"("             { return LPAREN; }
")"             { return RPAREN; }
"{"             { return LBRACE; }
"}"             { return RBRACE; }
","             { return COMMA; }

[0-9]+ { yylval.intval = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return ID; }

[\n] { yylineno++;}

[ \t\r]+ { /*ignorowanie spacji*/ }
. {

}

%%

int yywrap(void) {
    return 1;
}