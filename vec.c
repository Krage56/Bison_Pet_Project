#include "vec.h"
#include "ast.h"
#include <stddef.h>
#include <stdlib.h>

struct Vec* initVec(){
    struct Vec* v = malloc(sizeof(struct Vec));
    v->_size = 0;
    v->_cap = 5;
    v->_coef = 1.5;
    v->data = (struct Node**)malloc(v->_cap);
    return v;
}

int resize_vec(struct Vec* vec){
    int s = (int)(vec->_coef * (float)vec->_cap);
    vec->data = (struct Node**)realloc(vec->data, s * sizeof(struct Node*));
    vec->_cap = s;
    return s;
}

void push_back(struct Vec* v, struct Node* data){
    if (v->_size + 1 == v->_cap){
        resize_vec(v);
    }
    v->data[v->_size] = data;
    v->_size += 1;
}

void free_vec(struct Vec* vec){
    for (struct Node** i = vec->data; i < vec->data + vec->_size; ++i){
        free(*i);
    }
    free(vec->data);
}

struct Node* pop_back(struct Vec* v){
    struct Node* t = v->data[v->_size - 1];
    v->data[v->_size - 1] = NULL;
    v->_size -= 1;
    return t;
}