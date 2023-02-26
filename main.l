%{
#include "main.tab.h"
#include <stdlib.h>
%}

%option noyywrap yylineno

INT [0-9]+
%%

"("  {return LBRACE;}
")"  {return RBRACE;}
"{" {return FLBRACE;}
"}" {return FRBRACE;}
{INT}   {yylval.i = atoi(yytext);return INT;}
";"    {return SEMI;}
":"   {return COLON;}
"SWITCH"  {return SWITCH;}
"CASE"    {return CASE;}
"BREAK"   {return BREAK;}
"DEFAULT" {return DEFAULT;}
"PRINT"   {return PRINT;}
