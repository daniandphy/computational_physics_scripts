
#include <stdlib.h>
#include <stdio.h>
#include "Flow.h"

//void getRes(flowPtr *Flow, FILE *res1file, FILE *res2file)
void getRes(flowPtr *Flow, int source, int target)
{
  //int i;
  //char line[100];

  *Flow = malloc(sizeof(flowStr));
  //(*Flow)->nres1 = 0;
  (*Flow)->nres1 = 1;

  /*while (fgets(line, 100, res1file) != NULL)
    (*Flow)->nres1 = (*Flow)->nres1 + 1;
    printf("Number of residues at one end of signal transmitted is %d.\n", (*Flow)->nres1);*/
  //(*Flow)->nres2 = 0;
  (*Flow)->nres2 = 1;

  /*while (fgets(line, 100, res2file) != NULL)
    (*Flow)->nres2 = (*Flow)->nres2 + 1;
    printf("Number of residues at other end of signal transmitted is %d.\n", (*Flow)->nres2);*/
  
  if (((*Flow)->source = (int *) calloc((*Flow)->nres1, sizeof(int))) == NULL)
    printf("No memory space allocatable for reading Residue 1 selection.\n");
  if (((*Flow)->target = (int *) calloc((*Flow)->nres2, sizeof(int))) == NULL)
    printf("No memory space allocatable for reading Residue 2 selection.\n");

  /*rewind(res1file);
    rewind(res2file);
    for (i=0; i<(*Flow)->nres1; i++) {                                                   
    fscanf(res1file, "%d", &((*Flow)->source[i]));
    }
    for (i=0; i<(*Flow)->nres2; i++) {
    fscanf(res2file, "%d", &((*Flow)->target[i]));
    }
    fclose(res1file);
    fclose(res2file);*/

  (*Flow)->source[0] = source;
  (*Flow)->target[0] = target;

  return;
}
