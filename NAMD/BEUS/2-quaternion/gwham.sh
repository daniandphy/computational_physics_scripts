#!/bin/bash

ROOT="." # where my files are

# first generate the datat ponints (all the potentials) from the trajectory files
# I use U(q,q_ref)=k/2 (acos(q.q_ref))^2 to get the potentials.
if (( 1 ))
then
    rm data.txt
    for l in `seq 2 5` # the data from job2,job3,... to be used
    do
    for i in `seq 0 5`
    do
	cat $ROOT/output/$i/rotate.job$l.$i.sort.colvars.traj | \
	awk -v i=$i '
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
	    pi=3.141592653589793
	    ua[1]=0.626315
	    ua[2]=0.765614
	    ua[3]=-0.146849
	    ub[1]=0.512386
	    ub[2]=-0.848032
	    ub[3]=0.135286
	    a[0]=7.11359
	    b[0]=1.45346
	    k[0]=400
	    a[1]=5.69087
	    b[1]=1.16277
	    k[1]=400
	    a[2]=4.26815
	    b[2]=0.872076
	    k[2]=400
	    a[3]=2.84544
	    b[3]=0.581384
	    k[3]=500
	    a[4]=1.42272
	    b[4]=0.290692
	    k[4]=400
	    a[5]=0.0
	    b[5]=0.0
	    k[5]=600
	    for (l=0;l<=5;l++) {
		a[l]*=pi/180
		b[l]*=pi/180
	    }
	}{
	    if ($1 !~ /#/) {
		x1=$3;x2=$5;x3=$7;x4=$9;x5=$12;x6=$14;x7=$16;x8=$18;
		printf "%d %d",i,$1;
		for (j=0;j<6;j++) {
	    	    o1=acos((x1*cos(a[j])+sin(a[j])*(ua[1]*x2+ua[2]*x3+ua[3]*x4)));
	    	    o2=acos((x5*cos(b[j])-sin(b[j])*(ub[1]*x6+ub[2]*x7+ub[3]*x8)));
	    	    printf " %f",0.5*k[j]*(o1*o1+o2*o2);
		}
		print "";
    	    }
	}' >> data.txt
    done
    done
fi

# Now I can use gwham to get the unbiased probabilities

l=`wc data.txt | awk '{print $1}'` # Here I choose how many lines (data points) I want to use (one can make different blocks etc for error estimate)
head -$l data.txt | ./gwham -w 6 -l $l > density.txt 2> den.err
