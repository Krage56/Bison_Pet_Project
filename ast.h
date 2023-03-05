enum TYPES { TSWITCH, TCASEARR, TCASE, TDEFAULT, TPRINT, TPAYLOAD, TBREAK };

struct Node{
  struct Vec *children;
  struct Node *parent;
  int data;
  // Тип узла
  short type;
};

struct Node* initNode();

//Добавить потомка в Node
int addChild(struct Node* node, struct Node* child);

//Удалить узел и все узлы ниже
void delBranch(struct Node* victim);

//Вывести результат по итоговому дереву
void printResultFromAST(struct Node* root);