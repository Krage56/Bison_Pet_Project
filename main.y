%{
#include "ast.h"
#include "vec.h"
#include <stdio.h>
extern int yylineno;
struct Node* root;
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
%type <child> st_switch body_switch case_array st_case payload st_default
%%
st_switch: SWITCH LBRACE INT RBRACE body_switch
        {
          $$ = $5;
          $$->type = TSWITCH;
          $$->data = $3;
          printf("Switch %p with val %d has %d children\n", (void*)$$, $$->data, $$->children->_size);
          printf("Switch's first child %p, second child %p\n", (void*)($$->children->data[0]), (void*)($$->children->data[1]));
            for (int i = $$->children->_size - 1; i >= 0 ; --i)
            {
              printf("%d\n", i);
              printf(
                "Child with pointer %p, type %d, data %d and parent %p\n", 
                (void*)($$->children->data[i]),
                $$->children->data[i]->type,
                $$->children->data[i]->data,
                (void*)($$->children->data[i]->parent)
              );
            }
            // //Уничтожим потомков, которые не удовлетворяют условию switch
            int perm = 0;
            for (int i = $$->children->_size - 1; i >= 0 ; --i)
            {
              if ((perm == 0) && ($$->children->data[i]->type == TCASE))
              {
                printf("Big for, perm 0 & TCASE: %d\n", i);
                if ($$->children->data[i]->data == $$->data)
                {
                  perm = 1;
                  printf("Big for, perm 0 & TCASE & data matched: %d\n", i);
                  //take children throught payload
                  struct Vec* grandsons = $$->children->data[i]->children->data[0]->children;
                  printf("Grandsons quantity is %d and type is %d\n", grandsons->_size, grandsons->data[0]->type);
                  for (int j = grandsons->_size - 1; j >= 0; --j)
                  {
                    //если внутри case есть break, то содержимое следующих case-ов выводиться не должно
                    if ((perm == 1) && (grandsons->data[j]->type == TBREAK))
                    {
                      perm = -1;
                      delBranch(pop_from_pos(grandsons,j));
                    }
                    //удалим всё, что идёт после break
                    else if (perm == -1)
                    {
                      delBranch(pop_from_pos(grandsons, j));
                    }
                  }
                }
                else
                {
                  printf("Big for, perm 0 & TCASE value unmatch: %d\n", i);
                  struct Node* t = pop_from_pos($$->children, i); 
                  printf("Victim branch is %p\n", (void*)t);
                  delBranch(t);
                }
              }
              else if ((perm == 0) && ($$->children->data[i]->type == TDEFAULT))
              {
                perm = 1;
              }
              else if ((perm == -1) && (($$->children->data[i]->type == TDEFAULT) || ($$->children->data[i]->type == TCASE)))
              {
                printf("Big for, perm -1: %d\n", i);
                delBranch(pop_from_pos($$->children, i));
              }
            }
          root = $$;
        };
body_switch: FLBRACE case_array FRBRACE {$$ = $2;};
case_array: st_case case_array 
        {
            printf("Указатель на st_case %p, указатель на case_array %p\n", (void*)$1, (void*)$2);
            $$ = $2;
            addChild($$, $1);
            printf("case_array %p add a child-case %p\n", (void*)$$, (void*)$1);
        }
          | st_default
        {
          struct Node* case_array = initNode();
          case_array->type = TCASEARR;
          $$ = case_array;
          addChild($$, $1);
          printf("DEFAULT with pointer %p and child %p added to case_array %p\n", (void*)$1, (void*)$1->children->data[0], (void*)$$);
        }
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
          printf("st_switch pointer is %p, left payload pointer is %p, right payload pointer is %p\n", (void*)$1, (void*)$2, (void*)$$);
          $$ = $2;
          addChild($2, $1);
          printf("Switch with pointer %p appended to the payload %p\n", (void*)$1, $$);  
        }
       | PRINT LBRACE INT RBRACE SEMI payload 
        {
            struct Node* print = initNode();
            print->type = TPRINT;
            print->data = $3;
            $$ = $6;
            addChild($$, print);
            printf("PRITN(%d) with pointer %p added to payload %p\n", $3, (void*)print, (void*)$$);
        }
       | BREAK SEMI payload
       {
          printf("BREAK rules\n");
          $$ = $3;
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
st_default: DEFAULT COLON payload
      {
        $$ = initNode();
        $$->type = TDEFAULT;
        addChild($$, $3);     
        printf("Init DEFAULT with pointer %p with payload %p\n", (void*)$$, (void*)$3);
      };

%%

#include <stdio.h>
#include <stdio.h>
main() { 
  yyparse(); 
  printf("root is %p\n", (void*)root);
  printResultFromAST(root);
  delBranch(root);
}
yyerror( mes ) char *mes; {  printf( "%s", mes ); }

