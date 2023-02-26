struct Vec{
    int _cap;
    int _size;
    float _coef;
    struct Node** data;
};

struct Vec* initVec(); 

//Положить данные в конец
void push_back(struct Vec* v, struct Node* data);

//Снять данные с конца
struct Node* pop_back(struct Vec* v);

//Очистить массив прочитанных данных
void free_vec(struct Vec* vec);

//Увеличить внутренний массив в соответствии с коэффициентом
int resize_vec(struct Vec* vec);