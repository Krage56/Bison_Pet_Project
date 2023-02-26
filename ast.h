enum TYPES { TSWITCH, TCASE, TDEFAULT, TPRINT };

struct Node{
  struct Node **children;
  int data;
  // Тип узла
  short type;
  // количество потомков
  int ch_num;
};
