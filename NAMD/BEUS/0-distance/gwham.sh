#!/bin/bash

# example of gwham usage

# firs step: preparing the data
if (( 1 ))
then

N=30 # number of replicas
ROOT="../output" # e.g. ../../US/rotate.job

x0=" -45    -42    -35    -30    -26.5  -25    -24    -23    -22    -21    -20    -19    -18    -17.5  -17    -16.5  -16    -15.5  -15    -14    -13    -12    -11    -10.5  -10    -9.5   -9     -8.5   -8.3   -8.15  " # these are my centers
k=" 0.002 0.002 0.002 0.05 0.05 0.05 0.05 1    0.5  0.5  0.5  0.5  1    2    3    4    3    2    1    1    1    1    1     1    1    1    1    1.5  3    6   " # these are my harmonic constants

if [ -f data.txt ]; then rm data.txt; fi # the data will be collected here

for l in `seq 3 16` # these are runs that I will consider for wham (job3,job4,...)
do
for i in `seq 0 $((N-1))` # these are my replicas
do
    cat ${ROOT}/$i/move.job${l}.${i}.sort.colvars.traj | \
    awk -v N=$N -v i=$i -v k="$k" -v x0="$x0" '
    BEGIN{
	split(x0,X0)
	split(k,K)
    }($1 !~ /#/){
	    t=$1
	    x=$2
	    printf "%d %d",i,t
	    for (j=0;j<N;j++) printf " %f",0.5*K[j]*(x-X0[j])*(x-X0[j])
	    printf "\n"
	}' >> data.txt

  
done
done

fi

# second step: run the gwham
if (( 1 ))
then

#    Generalized Weighted Histogram Method (gwham)
#    Based on C. Bartels, "Analyzing Biased Monte Carlo and Molecular Dynamics Simulations", Chem. Phys. Letters 331:446 (2000)
#    Written by Mahmoud Moradi, UIUC (last modified on 2/23/2013)
#    Usage:  stdin: data
#	    stdout: optimized probabilities
#	    stderr: log file; also including optimized proportionality factors
#	    arguments:
#	    --windows (-w) number of windows (default: 1)
#            --lines (-l) number of data points (lines) read from the stdandard input  (default: 1)
#                        Each line (in stdin) includes "i t u_0 u_1 ... "
#                                  t and i are the time and window index (both integers)
#                                  u_i is the biasing potential associated with the window i
#            --iterations (-i) maximum number of iterations for self-consistent solution (default: 1000)
#            --accuracy (-a) accuracy in kcal/mol for self-consistent solution (default: 0.1)
#            --temperature (-t) simulation temperature in Kelvin (default: 300)
#	     --restart (-r) a filename to store resulted p's and f's to continue iterations (default: "")
#            --start (s) an existing restart file to continue iterations (default: "")
#    Program generates the {p(i,t)} probability for each data point "i t p" (in stdout)

l=`wc data.txt | awk '{print $1}'` # number of data points
cat data.txt | ./gwham -w $N -l $l > density.txt 2> density.err

fi
