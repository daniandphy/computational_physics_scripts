#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "Graph.h"
#include "alignment.h"
#include "networkComparison.h"

int main (int argc, char *argv[])
{
	FILE *input, *output;
	Alignment Aln;
	Alignment *AlnPtr;
	int i;
	char fileName[200];
	
	if (argc != 5) {
		/*printf("Error in number of arguments. \n");*/
		printf("The command line should be of the format: \n");
		printf(">./Evolution <alignmentFile> <networkFilesList> <pdbFilesList> <output> \n");
		printf(" where:\n");
		printf("   alignmentFile is file with alignment.\n");
		printf("   networkFilesList is the file with names of files for the networks for different molecules in the same order as the molecules are in the alignment\n");
		printf("   pdbFilesList is the file with names of files for the pdb files for different molecules in the same order as the molecules in the alignment\n");
		printf("   output is the name for output directory (directory should exist)\n");
		exit(1);
	}
	
	//Reading Alignment
	if ( (input=fopen(argv[1], "r")) == NULL ) {
		printf("Alignment file does not exist.\n");
		exit(1);
	}
	
	AlnPtr = &Aln;
	readSequenceAlignment(AlnPtr, input);
	mappingSequenceAlignment(AlnPtr);
	fclose(input);
	
	//Reading networks
	if ((input=fopen(argv[2], "r")) == NULL) {
		printf("File for list of network files does not exist. \n");
		exit(1);
	}
	readNetworkFiles(AlnPtr, input);
	fclose(input);
	
	//Reading pdb file names
	if ( (input=fopen(argv[3], "r")) == NULL ) {
		printf("File for list of pdb files does not exist.\n");
		exit(1);
	}
	readPdbFileNames(AlnPtr, input);
	fclose(input);
	
	//Creating and opening output files for each sequence
	for (i=0; i<AlnPtr->Nseq; i++) {
		AlnPtr->Sequence[i]->fileName[0] = '\0';
		strcat(AlnPtr->Sequence[i]->fileName, argv[4]);
		strcat(AlnPtr->Sequence[i]->fileName, "/");
		strcat(AlnPtr->Sequence[i]->fileName, AlnPtr->Sequence[i]->name);
		strcat(AlnPtr->Sequence[i]->fileName, ".out");
		//printf("fileName is %s\n",fileName);
		output=fopen(AlnPtr->Sequence[i]->fileName, "w");
		fprintf(output, "Name %s\n", AlnPtr->Sequence[i]->name);
		fprintf(output, "PDB file %s", AlnPtr->Sequence[i]->pdbName);
		fprintf(output, "Network file %s\n", AlnPtr->Sequence[i]->networkName);
		fclose(output);
	}
	
	//Creating Alignment Edges
	AlnPtr->Nedges = numberEdgesAlignment(AlnPtr);
	createAlnEdges(AlnPtr);
	
	//Calculating conservation of nodes and edges in the alignment
	nodeConservation(AlnPtr);
	edgeConservation(AlnPtr);
	
	numberEdgeMatches(AlnPtr);
	fileName[0] = '\0';
	strcat(fileName, argv[4]);
	strcat(fileName, "/");
	strcat(fileName, "edgeIdentity.dis");
	output=fopen(fileName, "w");
	calculateEdgeIdentity(AlnPtr,output);
	fclose(output);
	
	calculateShortestDistance(AlnPtr);
	fileName[0] = '\0';
	strcat(fileName, argv[4]);
	strcat(fileName, "/");
	strcat(fileName, "shortestDistance.dis");
	output=fopen(fileName, "w");
	diffShortestDistanceAligned(AlnPtr,output);
	fclose(output);
	
	deleteAlignment(AlnPtr);
	return 0;
}


