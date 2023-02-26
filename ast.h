enum TYPES { TSWITCH, TCASEARR, TCASE, TDEFAULT, TPRINT };

struct Node{
  struct Vec *children;
  struct Node *parent;
  int data;
  // Тип узла
  short type;
  // количество потомков
  int ch_num;
};

struct Node* initNode();

//Добавить потомка в Node
int addChild(struct Node* node, struct Node* child);

//Удалить последнего ребёнка
struct Node* rmLastChild(struct Node* node);