# Лабораторная работа Bison + Flex
## Грамматика

<st_switch> ::= SWITCH(INT)<body_switch><br>
<body_switch> ::= {<case_arr>}<br>
<case_arr> ::= <st_case><case_arr> | <st_default> | e<br>
<st_case> ::= CASE INT:\<payload><br>
\<payload> ::= <st_switch>\<payload> | print(INT); \<payload> | BREAK; \<payload> | e<br>
<st_default> ::= DEFAULT:<payload>

## Запуск
```console
./make.sh
./switch < t.c
```