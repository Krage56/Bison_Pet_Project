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
            // //Уничтожим потомков, которые не удовлетворяют условию switch
            int perm = 0;
            for (int i = $$->children->_size - 1; i >= 0 ; --i)
            {
              if ((perm == 0) && ($$->children->data[i]->type == TCASE))
              {
                if ($$->children->data[i]->data == $$->data)
                {
                  perm = 1;
                  //take children throught payload
                  struct Vec* grandsons = $$->children->data[i]->children->data[0]->children;
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
                  struct Node* t = pop_from_pos($$->children, i); 
                  delBranch(t);
                }
              }
              else if ((perm == 0) && ($$->children->data[i]->type == TDEFAULT))
              {
                perm = 1;
              }
              else if ((perm == -1) && (($$->children->data[i]->type == TDEFAULT) || ($$->children->data[i]->type == TCASE)))
              {
                delBranch(pop_from_pos($$->children, i));
              }
            }
          root = $$;
        };
body_switch: FLBRACE case_array FRBRACE {$$ = $2;};
case_array: st_case case_array 
        {
            $$ = $2;
            addChild($$, $1);
        }
          | st_default
        {
          struct Node* case_array = initNode();
          case_array->type = TCASEARR;
          $$ = case_array;
          addChild($$, $1);
        }
          | /**/
        {
            $$ = initNode();
            $$->type = TCASEARR;
        }
          ;
st_case: CASE INT COLON payload
        {
            struct Node* st_case = initNode();
            st_case->type = TCASE;
            st_case->data = $2;
            addChild(st_case, $4);
            $$ = st_case;
        };
payload: st_switch payload
        {
          $$ = $2;
          addChild($2, $1);
        }
       | PRINT LBRACE INT RBRACE SEMI payload 
        {
            struct Node* print = initNode();
            print->type = TPRINT;
            print->data = $3;
            $$ = $6;
            addChild($$, print);
        }
       | BREAK SEMI payload
       {
          $$ = $3;
          struct Node* br = initNode();
          br->type = TBREAK;
          addChild($$, br);
       }
       | /**/
       {
            $$ = initNode();
            $$->type = TPAYLOAD;
        }
       ;
st_default: DEFAULT COLON payload
      {
        $$ = initNode();
        $$->type = TDEFAULT;
        addChild($$, $3);     
      };

%%

#include <stdio.h>
#include <stdio.h>
main() { 
  yyparse(); 
  printResultFromAST(root);
  delBranch(root);
}
yyerror( mes ) char *mes; {  /*printf( "%s", mes );*/ }

