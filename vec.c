#include "vec.h"
#include "ast.h"
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
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
    if (v->_size + 1 >= v->_cap){
        resize_vec(v);
    }
    v->data[v->_size] = data;
    v->_size += 1;
}

void free_vec(struct Vec* vec){
    for (int i = 0; i < vec->_size; ++i){
        printf("Object on %p with type %d and data %d have been freed\n", (void*)(vec->data[i]), vec->data[i]->type, vec->data[i]->data);
        free(vec->data[i]);
    }
    printf("Object on %p have been freed\n", (void*)(vec->data));
    free(vec->data);
    printf("Object on %p have been freed\n", (void*)(vec));
    free(vec);
}

struct Node* pop_back(struct Vec* v){
    struct Node* t = v->data[v->_size - 1];
    v->data[v->_size - 1] = NULL;
    v->_size -= 1;
    return t;
}

struct Node* pop_from_pos(struct Vec* vec, int pos){
    struct Node* t = vec->data[pos];
    for(int j = pos; j < vec->_size - 1; ++j){
        vec->data[j] = vec->data[j + 1];
    }
    vec->_size -= 1;
    return t;
}