#ifndef TREE_H
#define TREE_H

/**
 * Linked list with pointers to both head and tail nodes to facilitate
 * both pushing and popping.
 */
struct Tree {
  int value;
  struct Tree *parent;
  struct Tree *child1;
  struct Tree *child2;
};

typedef struct Tree *treePtr;


/**
 * Constructor.
 * Create a new tree.
 * @param parent Parent for this tree, NULL if none.
 * @param val Value for this tree.
 * @return Newly created tree.
 */
treePtr newTree(treePtr parent, int val);

/**
 * Copy constructor.
 * Copy all of the member data into another Tree.
 * @param tree Tree to copy.
 * @return Newly created copy.
 */
treePtr copyTree(treePtr tree);

/**
 * Add child if there is none present already.
 * @param tree Tree to add the child to.
 * @param child Which child to add (1 or 2).
 * @param value Value for the child.
 * @return Pointer to child, NULL if unsuccessful.
 */
treePtr addChild(treePtr tree, int child, int value);

/**
 * Delete an entire linked list.
 * As the pointer may be deleted in this function, a pointer to the first
 * pointer is input to this function.
 * @param tree Pointer to head of linked list
 */
void deleteTree(treePtr tree);

/**
 * Determine if a tree contains a second tree.
 * The first tree is searched for an exact copy of the second tree
 * @param tree Pointer to root of tree.
 * @param matchTree Pointer to head of linked list to search for
 * @return 0 if there are no matches, 1 if at least one match exists
 */
int matchTree(treePtr tree, treePtr matchTree);

/**
 * Print out the linked list residues.
 * Prints out the residues in the whole linked list in the 
 * order they are pushed into the linked list. A pointer to the first element 
 * of the linked list is input to this function.
 * @param head Pointer to root of tree.
 */
void printTree(treePtr tree);

/**
 * Print out the linked list residues to a file.
 * Prints out the residues in the whole linked list in the 
 * order they are pushed into the linked list. A pointer to the first element 
 * of the linked list is input to this function.
 * @param file output file
 * @param head pointer to head of linked list
 */
void fprintTree(FILE *file, treePtr tree);

#endif
