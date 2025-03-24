%{
#include <math.h>
#include <string.h>
#include "y.tab.h"

void yyerror(const char *s);
%}

%option noyywrap

%%

[ \t]+              ;                // Ignore whitespace
\n                  { return '\n'; } // Let newline end expressions
[0-9]+\.[0-9]+      { yylval.dval = atof(yytext); return FLOAT; }
[0-9]+              { yylval.dval = atoi(yytext); return NUMBER; }
"+"                 { return PLUS; }
"-"                 { return MINUS; }
"*"                 { return TIMES; }
"/"                 { return DIVIDE; }
"^"                 { return POWER; }
"("                 { return LPAREN; }
")"                 { return RPAREN; }
"="                 { return ASSIGN; }
[a-zA-Z][a-zA-Z0-9]* {
    strncpy(yylval.sval, yytext, 49);
    yylval.sval[49] = '\0';
    return VARIABLE;
}
.                   { yyerror("Unexpected character"); }

%%
