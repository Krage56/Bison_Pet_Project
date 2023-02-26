bison -d -t main.y
flex -d main.l
gcc -o switch lex.yy.c main.tab.c ast.h