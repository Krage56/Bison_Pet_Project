%{
#include "ast.h"
#include "vec.h"
#include <stdio.h>
extern int yylineno;
%}

%union{
  int i;
  struct Node* child;
}

%token SWITCH
%token CASE
%token DEFAULT
%token BREAK
%token <child> PRINT
%token <i> INT
%token SEMI
%token FLBRACE
%token FRBRACE
%token COLON
%token LBRACE
%token RBRACE
%type <child> st_switch body_switch case_array st_case payload
%%
st_switch: SWITCH LBRACE INT RBRACE body_switch
        {
            $$ = initNode();
            $$->type = TSWITCH;
            addChild($$, $5);
            $$->data = $3;
        };
body_switch: FLBRACE case_array FRBRACE {$$ = $2;};
case_array: st_case case_array 
        {
            printf("Указатель на st_case %p, указатель на case_array %p\n", (void*)$1, (void*)$2);
            $$ = $2;
            addChild($$, $1);
        }
          | st_default
          | /**/
        {
            $$ = initNode();
            $$->type = TCASEARR;
            printf("Empty case array rule with node %p\n", (void*)$$);
        }
          ;
st_case: CASE INT COLON payload
        {
            struct Node* st_case = initNode();
            st_case->type = TCASE;
            st_case->data = $2;
            addChild(st_case, $4);
            $$ = st_case;
            printf("CASE(%d), case pointer is %p, payload pointer is %p\n", $2, (void*)$$, (void*)$4);
        };
payload: st_switch payload
       | PRINT LBRACE INT RBRACE SEMI payload 
        {
            struct Node* print = initNode();
            print->type = TPRINT;
            print->data = $3;
            struct Node* payload = initNode();
            addChild(print, payload);
            $$ = print;
            $6 = payload;
            printf("PRITN(%d), print pointer is %p, payload pointer is %p\n", $3, (void*)$$, (void*)$6);
        }
       | BREAK SEMI payload
       | /**/{printf("Empty rule\n");}
       ;
st_default: DEFAULT COLON payload;

%%

#include <stdio.h>
main() { yyparse(); }
yyerror( mes ) char *mes; {  printf( "%s", mes ); }

