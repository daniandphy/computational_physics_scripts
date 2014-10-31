#!/bin/bash

ROOT="." # this is where my files are (supposed to be)

kA="20.0 50.0 70.0 65.0 65.0 50.0 50.0 75.0 75.0 60.0 65.0 75.0"
kB="50.0 50.0 70.0 50.0 50.0 30.0 50.0 75.0 75.0 45.0 65.0 75.0"

# generate potentials from colvar trajectories
if (( 1 ))
then
rm data.txt
for l in `seq 2 5` # job2,job3,job4,job5
do
for i in `seq 0 11` # replicas 0,1,...,11
do
    cat $ROOT/output/$i/rotate.job$l.$i.sort.colvars.traj | \
    awk -v i=$i -v kA="$kA" -v kB="$kB" '
    function abs(a) {
	if(a<0) a=-a;
        return a;
    }
    function asin(a) {
	return atan2(a, sqrt(1 - a * a))
    }
    function acos(a) {
	pi=3.141592653589793
	if(abs(a)==1) {
	    return (1-a)*pi/2  
	} else {
	    return atan2(-a,sqrt(1-a*a))+2*atan2(0.5,0.5)
        }
    }
    BEGIN{
	pi=3.141592653589793;
	split(kA,KA)
	split(kB,KB)
    }($1 !~ /#/) {
	t=$1
	printf "%d %d",i,t
	for (j=0;j<12;j++) {
	    xA=acos($(3+18*j))
	    xB=acos($(12+18*j))
	    printf " %f",0.5*(KA[j]*xA*xA+KB[j]*xB*xB)
	}
	printf "\n";
    }' >> data.txt
done
done
fi

# Now I can use gwham to get the unbiased probabilities

l=`wc data.txt | awk '{print $1}'` # Here I choose how many lines (data points) I want to use (one can make different blocks etc for error estimate)
head -$l data.txt | \
./gwham -w 12 -l $l > density.txt 2> den.err
