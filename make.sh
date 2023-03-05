bison -d main.y
flex main.l
gcc -o switch lex.yy.c main.tab.c vec.c ast.c