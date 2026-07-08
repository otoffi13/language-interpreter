%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    void yyerror(const char *s);
    int yylex(void);
    extern int yylineno;


    typedef struct Var {
        char *name;
        int value;
        struct Var *next;
    } Var;

    Var *var_list = NULL;

    int get_var(const char *name);
    void set_var(const char *name, int value);

%}

%union {
    int intval;
    char *sval;
}

%token <sval> ID;
%token <intval> NUMBER;
%token IF WHILE PRINT INPUT
%token AND OR NOT
%token ASSIGN
%token PLUS MINUS MULTIPLY DIVIDE
%token EQUAL NOTEQUAL LESS LESS_EQUAL GREATER GREATER_EQUAL
%token LPAREN RPAREN LBRACE RBRACE COMMA

%type <intval> expr
%%

program:
    statements
    ;

statements:
    statements statement
    | statement
    ;

statement:
    ID ASSIGN expr { set_var($1, $3); free($1); }
    | PRINT LPAREN expr RPAREN
        { printf("%d\n", $3); }
    | INPUT LPAREN ID RPAREN
        {
            int x;
            FILE *tty = fopen("/dev/tty", "r");
            if (!tty) {
                fprintf(stderr, "[Błąd] Nie mogę otworzyć terminala do pobierania danych!\n");
                exit(1);
            }
            printf("Podaj %s: ", $3);
            fflush(stdout);
            fscanf(tty, "%d", &x);
            fclose(tty);
            set_var($3, x);
            free($3);
        }
;

expr:
    NUMBER { $$ = $1; }
    | ID { $$ = get_var($1); free($1); }
    | PLUS LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Dodawanie: %d + %d = %d\n", $3, $5, $3 + $5);
        $$ = $3 + $5;
    }
    | MINUS LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Odejmowanie: %d - %d = %d\n", $3, $5, $3 - $5);
        $$ = $3 - $5;
    }
    | MULTIPLY LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Mnożenie: %d * %d = %d\n", $3, $5, $3 * $5);
        $$ = $3 * $5;
    }
    | DIVIDE LPAREN expr COMMA expr RPAREN {
        if ($5 == 0) {
            printf("[Uwaga] Dzielenie przez zero\n");
            $$ = 0;
        } else {
            printf("[DEBUG] Dzielenie: %d / %d = %d\n", $3, $5, $3 / $5);
            $$ = $3 / $5;
        }
    }
    | EQUAL LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie == : %d == %d = %d\n", $3, $5, $3 == $5);
        $$ = $3 == $5;
    }
    | NOTEQUAL LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie != : %d != %d = %d\n", $3, $5, $3 != $5);
        $$ = $3 != $5;
    }
    | LESS LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie < : %d < %d = %d\n", $3, $5, $3 < $5);
        $$ = $3 < $5;
    }
    | LESS_EQUAL LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie <= : %d <= %d = %d\n", $3, $5, $3 <= $5);
        $$ = $3 <= $5;
    }
    | GREATER LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie > : %d > %d = %d\n", $3, $5, $3 > $5);
        $$ = $3 > $5;
    }
    | GREATER_EQUAL LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Porównanie >= : %d >= %d = %d\n", $3, $5, $3 >= $5);
        $$ = $3 >= $5;
    }
    | AND LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Koniunkcja: %d && %d = %d\n", $3, $5, $3 && $5);
        $$ = $3 && $5;
    }
    | OR LPAREN expr COMMA expr RPAREN {
        printf("[DEBUG] Alternatywa: %d || %d = %d\n", $3, $5, $3 || $5);
        $$ = $3 || $5;
    }
    | NOT LPAREN expr RPAREN {
        printf("[DEBUG] Negacja: !%d = %d\n", $3, !$3);
        $$ = !$3;
    }
;
%%

int get_var(const char *name) {
    Var *v = var_list;
    while (v) {
        if (strcmp(v->name, name) == 0)
            return v->value;
        v = v->next;
    }
    fprintf(stderr, "[Błąd] Nieznana zmienna '%s'\n", name);
    exit(1);
}

void set_var(const char *name, int value) {
    Var *v = var_list;
    while (v) {
        if (strcmp(v->name, name) == 0) {
            v->value = value;
            printf("[DEBUG] Nadpisano zmienną %s = %d\n", name, value);
            return;
        }
        v = v->next;
    }

    Var *new_var = malloc(sizeof(Var));
    new_var->name = strdup(name);
    new_var->value = value;
    new_var->next = var_list;
    var_list = new_var;
    printf("[DEBUG] Utworzono zmienną %s = %d\n", name, value);
}

void yyerror(const char *s) {
    fprintf(stderr, "[Błąd] Linia %d: %s\n", yylineno, s);
}
