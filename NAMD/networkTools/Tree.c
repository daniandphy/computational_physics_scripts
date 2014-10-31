#include <stdlib.h>
#include <stdio.h>
#include "Tree.h"


treePtr newTree(treePtr parent, int val)
{
  treePtr newTree = (treePtr) malloc(sizeof(struct Tree));
  newTree->value = val;
  newTree->parent = parent;
  newTree->child1 = NULL;  
  newTree->child2 = NULL;  

  return newTree;
}


treePtr copyTree(treePtr tree)
{
  //printf("->copyTree\n");
  if (tree == NULL) {
    return NULL;
  }

  treePtr newTree = (treePtr) malloc(sizeof(struct Tree));
  newTree->value = tree->value;
  newTree->parent = NULL;
  newTree->child1 = copyTree(tree->child1);
  newTree->child1->parent = newTree;
  newTree->child2 = copyTree(tree->child2);
  newTree->child2->parent = newTree;

  //printf("<-copyTree\n");
  return newTree;
}


treePtr addChild(treePtr tree, int child, int value)
{
  treePtr success = NULL;

  if (child == 1 &&
      tree->child1 == NULL) {
    tree->child1 = newTree(tree,value);
    success = tree->child1;
  } else if (child == 2 &&
	     tree->child2 == NULL) {
    tree->child2 = newTree(tree,value);
    success = tree->child2;
  }

  return success;
}


void deleteTree(treePtr tree)
{

  if (tree != NULL) {
    deleteTree(tree->child1);
    deleteTree(tree->child2);
    free(tree);
  }

  return;
}


int matchTree(treePtr tree, treePtr matchTree)
{
  int match = 0;
  //treePtr treeNode = tree;
  //treePtr matchTreeNode = matchTree;

  return match;
}


void printTree(treePtr tree)
{

  //printf(">printTree\n");
  if (tree->child1 != NULL &&
      tree->child2 != NULL) {
    printf("(");
    printTree(tree->child1);
    printf(",");
    printTree(tree->child2);
    printf(")");
  } else if (tree->child1 != NULL) {
    printf("(");
    printTree(tree->child1);
    printf(")");
  } else if (tree->child2 != NULL) {
    printf("(");
    printTree(tree->child2);
    printf(")");
  }
  printf("%d",tree->value);

  //printf("<printTree\n");
  return;
}


void fprintTree(FILE *file, treePtr tree)
{
  //printf(">fprintTree\n");
  if (tree->child1 != NULL &&
      tree->child2 != NULL) {
    fprintf(file,"(");
    fprintTree(file,tree->child1);
    fprintf(file,",");
    fprintTree(file,tree->child2);
    fprintf(file,")");
  } else if (tree->child1 != NULL) {
    fprintf(file,"(");
    fprintTree(file,tree->child1);
    fprintf(file,")");
  } else if (tree->child2 != NULL) {
    fprintf(file,"(");
    fprintTree(file,tree->child2);
    fprintf(file,")");
  }
  fprintf(file,"%d",tree->value);

  //printf("<fprintTree\n");
  return;
}
