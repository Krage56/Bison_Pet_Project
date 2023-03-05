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
            $$ = $5;
            $$->type = TSWITCH;
            $$->data = $3;
            printf("Switch's (%p) children are:\n", (void*)$$);
            for (int i = 0; i < $$->children->_size; ++i)
            {
              printf(
                "Child with pointer %p, type %d, data %d and parent %p\n", 
                (void*)($$->children->data[i]),
                $$->children->data[i]->type,
                $$->children->data[i]->data,
                (void*)($$->children->data[i]->parent)
                );
            }
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
            struct Node* p = $4;
            for (int i = 0; i < p->children->_size; ++i)
            {
              printf("Child number %d with type %d and pointer %p\n", i, p->children->data[i]->type, (void*)p->children->data[i]);
            }
        };
payload: st_switch payload
        {
          struct Node* sw = initNode();
          sw->type = TSWITCH;
          $1 = sw;
          $$ = $2;
          addChild($$, $1);  
        }
       | PRINT LBRACE INT RBRACE SEMI payload 
        {
            struct Node* print = initNode();
            print->type = TPRINT;
            print->data = $3;
            $$ = $6;
            addChild($$, print);
            // printf("Left: %p, Right: %p\n", (void*)$$, (void*)$6);
            printf("PRITN(%d) with pointer %p\n", $3, (void*)print);
        }
       | BREAK SEMI payload
       {
          printf("BREAK rules\n");
          $$ = $3;
          // printf("Left: %p, Right: %p\n", (void*)$$, (void*)$3);
          struct Node* br = initNode();
          br->type = TBREAK;
          addChild($$, br);
          printf("BREAK with pointer %p\n", (void*)br);
       }
       | /**/
       {
            $$ = initNode();
            $$->type = TPAYLOAD;
            printf("Empty payload rule with node %p\n", (void*)$$);
        }
       ;
st_default: DEFAULT COLON payload;

%%

#include <stdio.h>
main() { yyparse(); }
yyerror( mes ) char *mes; {  printf( "%s", mes ); }

