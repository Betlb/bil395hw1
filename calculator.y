%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <unistd.h> // for isatty

// Function prototypes
void yyerror(const char *s);
int yylex(void);
int yyparse(void);
int error_flag = 0;


// Symbol table for variables
#define MAX_VARS 100
struct {
    char name[50];
    double value;
} symbol_table[MAX_VARS];
int symbol_count = 0;

double* find_or_add_variable(char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0) {
            return &symbol_table[i].value;
        }
    }
    if (symbol_count < MAX_VARS) {
        strncpy(symbol_table[symbol_count].name, name, 49);
        symbol_table[symbol_count].name[49] = '\0';
        symbol_table[symbol_count].value = 0.0;
        return &symbol_table[symbol_count++].value;
    }
    yyerror("Too many variables");
    return NULL;
}
%}

%union {
    double dval;
    char sval[50];
}

%token <dval> NUMBER FLOAT
%token <sval> VARIABLE
%token PLUS MINUS TIMES DIVIDE POWER
%token LPAREN RPAREN ASSIGN

%type <dval> expr

%right ASSIGN
%left PLUS MINUS
%left TIMES DIVIDE
%right POWER
%right UMINUS

%%

input:
      /* empty */
    | input line
    ;

line:
      expr '\n' { if (!error_flag) printf("Result: %g\n", $1); error_flag = 0; }
    | VARIABLE ASSIGN expr '\n' {
          if (!error_flag) {
              double* var = find_or_add_variable($1);
              if (var) *var = $3;
              printf("%s = %g\n", $1, $3);
          }
          error_flag = 0;
      }
    | '\n' { /* Just a blank line – do nothing */ }



expr:
      NUMBER         { $$ = $1; }
    | FLOAT          { $$ = $1; }
    | VARIABLE       {
          double* var = find_or_add_variable($1);
          $$ = var ? *var : 0.0;
      }
    | expr PLUS expr     { $$ = $1 + $3; }
    | expr MINUS expr    { $$ = $1 - $3; }
    | expr TIMES expr    { $$ = $1 * $3; }
    | expr DIVIDE expr   {
          if ($3 == 0.0) {
              yyerror("Division by zero");
          } else {
              $$ = $1 / $3;
          }
      }
    | expr POWER expr    { $$ = pow($1, $3); }
    | LPAREN expr RPAREN { $$ = $2; }
    | MINUS expr %prec UMINUS { $$ = -$2; }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    error_flag = 1;
}

int main() {
    if (isatty(fileno(stdin))) {
        // Only show intro in interactive mode
        printf("Advanced Calculator\n");
        printf("Features:\n");
        printf("- Floating-point numbers\n");
        printf("- Exponentiation (^)\n");
        printf("- Variable assignment\n");
        printf("Enter expressions (e.g., 3.5 + 5, x = 10, x ^ 2)\n");
        printf("Press Ctrl+D to exit\n");
    }
    yyparse();
    return 0;
}
