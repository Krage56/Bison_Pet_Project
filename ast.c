#include "ast.h"
#include "vec.h"
#include <stddef.h>
#include <stdlib.h>
int addChild(struct Node* node, struct Node* child){
    if (node->children == NULL){
        node->children = malloc(sizeof(struct Vec));       
    }
    push_back(node->children, child);
    child->parent = node;
}

struct Node* rmLastChild(struct Node* node){
    struct Node* t = pop_back(node->children);
    node->ch_num -= 1;
    return t;
}

struct Node* initNode(){
    struct Node* n = malloc(sizeof(struct Node));
    n->children = initVec();
    n->parent = NULL;
    n->ch_num = 0;
}