#include "ast.h"
#include "vec.h"
#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
int addChild(struct Node* node, struct Node* child){
    if (node->children == NULL){
        node->children = initVec();       
    }
    push_back(node->children, child);
    child->parent = node;
}

struct Node* initNode(){
    struct Node* n = malloc(sizeof(struct Node));
    n->children = initVec();
    n->parent = NULL;
}

void delBranch(struct Node* victim){
    struct Vec* queue = initVec();
    push_back(queue, victim);
    struct Node* cur_node;
    while (queue->_size != 0){
        cur_node = pop_from_pos(queue, 0);
        while(cur_node->children->_size != 0){
            push_back(queue, pop_back(cur_node->children));
        }
        free_vec(cur_node->children);
        free(cur_node);
    }
}

void printResultFromAST(struct Node* root){
    struct Vec* stack = initVec();
    push_back(stack, root);
    struct Node* cur_node;
    while (stack->_size != 0){
        cur_node = pop_back(stack);
        while(cur_node->children->_size != 0){
            push_back(stack, pop_from_pos(cur_node->children, 0));
        }
        if (cur_node->type == TPRINT){
            printf("%d\n", cur_node->data);
        }
    }
}