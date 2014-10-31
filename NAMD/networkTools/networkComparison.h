#ifndef NETWORKCOMPARISON_H
#define NETWORKCOMPARISON_H

#include "Community.h"
#include "List.h"
#include "Flow.h"
#include "Graph.h"


/**
 * Read a sequence alignment
 * @param Aln alignment for which the networks have to be read.
 * @param input input file from which to read the file names for all the networks
 */
void readNetworkFiles(Alignment *Aln, FILE *input);

/**
 * Find the number of edges in the alignment
 * @param Aln alignment to find number of edges for.
 */
int numberEdgesAlignment(Alignment *Aln);

/**
 * Create the edges in the alignment
 * @param Aln alignment to find number of edges for.
 */
void createAlnEdges(Alignment *Aln);

/**
 * Conservation of a node in an alignment
 * @param Aln alignment for which the conservation has to be calculated
 */
void nodeConservation(Alignment *Aln);

/**
 * Conservation of an edge in the alignment
 * @param Aln alignment for which the conservation has to be calculated
 */
void edgeConservation(Alignment *Aln);

/**
 * Number of edge matches between pair of sequence in the alignment
 * @param Aln alignment for which the identity has to be calculated
 */
void numberEdgeMatches(Alignment *Aln);

/**
 * Identity of edge matches between pair of sequences in the alignment
 * @param Aln alignment for which the identity has to be calculated
 * @param output output file to which edge identity distance matrix is written
 */
void calculateEdgeIdentity(Alignment *Aln, FILE *output);

/**
 * calculate shortest distance of all networks in the alignment
 * @param Aln alignment for which the shorest distance of all networks are calculated
 */
void calculateShortestDistance(Alignment *Aln);

/**
 * calculate the average of the difference in shortest path length between all pairs of aligned columns in two sequences
 * @param Aln alignment for which the calculations are done
 * @param output output file to which the average distance matrix is written
 */
void diffShortestDistanceAligned(Alignment *Aln, FILE *output);
 

#endif
