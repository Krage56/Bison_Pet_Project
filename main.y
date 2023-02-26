%{
#include "ast.h"
#include <stdio.h>
// #include "main.tab.h"
// #define YYSTYPE struct
extern int yylineno;
%}

%union{
  int i;
  struct Node* child;
}

%token <child> SWITCH
%token CASE
%token DEFAULT
%token BREAK
%token PRINT
%token <i> INT
%token SEMI
%token FLBRACE
%token FRBRACE
%token COLON
%token LBRACE
%token RBRACE

%%
st_switch: SWITCH LBRACE INT RBRACE body_switch
{
    struct Node* node = malloc(sizeof(struct Node));
    // printf("%d\n", sizeof(struct Node));
    node->type = TSWITCH;
    node->ch_num = 0;
    node->data = $3;
    printf("Switch condition is: %d\n", $3);
};
body_switch: FLBRACE case_array FRBRACE;
case_array: st_case case_array
          | st_default
          | /**/
          ;
st_case: CASE INT COLON payload;
payload: st_switch payload
       | PRINT LBRACE INT RBRACE SEMI payload
       | BREAK SEMI payload
       | /**/
       ;
st_default: DEFAULT COLON payload;

%%

#include <stdio.h>
main() { yyparse(); }
yyerror( mes ) char *mes; {  printf( "%s", mes ); }

