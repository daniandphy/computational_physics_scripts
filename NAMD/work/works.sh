#!/bin/bash

# This is an awk-based script to calculate work from nonequilibrium simulations
#              carried out using NAMD colvar module (with "harmonic" potential)

# by Mahmoud Moradi, UIUC (last modified on 4/11/2014)

# Usage:
# ./works.sh < colvar-config-file colvar-trajectory-1 colvar-trajectory-2 ... > work-file

# It reads the colvar config file (from standard input) and extracts the necessary information
# then it reads the colvar trajectories and generates the work profile
# Work file (standard output) contains:
# time, total accumulative work, total biasing potential, total transferable work, accumulative work 1, biasing potential 1, accumulative 2, ...

# Note: currently it works only for 1D colvars (e.g., rmsd, distance, angle, orientationAngle)
#       and orientation quaternions ("orientation").

# Note: It works with multiple harmonic but targetNumSteps is the same. If the harmonic is for time-independent restraining, you need to comment it out.

cat /dev/stdin | awk 'BEGIN{
	i=0;
	N=1;
	M=1;
}($1!~/#/){
    if ($1=="colvar") {
	if (i>0) {
	    if (!width[i]) {
		width[i]=1;
	    }
	    if (!type[i]) {
		type[i]=1;
	    }
	    m[i]=N+1;
	    N+=col*type[i];
	}
	i++;
	col=1;
    }
    if ($1=="name"&&!n) {
	name[i]=$2;
    }
    if ($1=="width") {
	width[i]=$2;
    }
    if ($0 ~ /outputAppliedForce/ && $0 ~ /(on|yes)/) {
	col++;
    }
    if ($0 ~ /outputSystemForce/ && $0 ~ /(on|yes)/) {
	col++;
    }
    if ($0 ~ /outputVelocity/ && $0 ~ /(on|yes)/) {
	col++;
    }
    if ($1=="orientation") {
	type[i]=9;
    }
    if ($1=="harmonic") {
	if (!harm) {
	    if (i>0) {
		if (!width[i]) {
		    width[i]=1;
		}
		if (!type[i]) {
		    type[i]=1;
		}
		m[i]=N+1;
		N+=col*type[i];
	    }
	    n=i
	    l_centers=0
	    l_target=0
	    cv=0
	}
	harm++
    }
    if ($1=="centers") {
	str=$0;
	gsub(/[,(){}]/," ",str)
	nitem=split(str,item)
	for (j=1;j<=nitem;j++) {
	    if (item[j]~/[0-9]/) {
		l_centers++
		x0[l_centers]=item[j]
	    }
	}
    }
    if ($1=="targetCenters") {
	str=$0;
	gsub(/[,(){}]/," ",str)
	nitem=split(str,item)
	for (j=1;j<=nitem;j++) {
	    if (item[j]~/[0-9]/) {
		l_target++
		x1[l_target]=item[j]
	    }
	}
	L=l_target;
    }
    if ($1=="colvars") {
        for (j=2;j<=NF;j++) {
	    for (i=1;i<=n;i++) {
		if (name[i]==$j) { 
		    cv++;
		    calc[i]=cv;
		    id[cv]=i;
		    m_[cv]=M;
		    harmK[cv]=harm
		    if (type[i]==9) M+=4; else M++;
		}
	    }
	    if (!calc[i]) {calc[i]=0;}
	}
	if (!q) {q=0;}
	if (!dt) {dt=100}
    }
    if ($1=="forceConstant") {
	K[harm]=$2;
    }
    if ($1=="targetNumSteps") {
	T=$2;
    }
    if ($1=="colvarsTrajFrequency") {
	dt=$2;
    }
}END{
    printf "%d %d %d %d %d ",T,dt,cv,L,N;
    for (l=1;l<=cv;l++) printf "%d %d %f %d ", m[id[l]],m_[l],K[harmK[l]]*1.0/(width[id[l]]*width[id[l]]),(type[id[l]]==9);
    for (l=1;l<=L;l++) printf "%f ", x0[l];
    for (l=1;l<=L;l++) printf "%f ", x1[l];
}' | awk -v input="`cat /dev/stdin`" '
function abs(a) {
    if(a<0) a=-a;
    return a;
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
    split(input,INPUT)
    T=INPUT[1];
    dt=INPUT[2];
    cv=INPUT[3];
    L=INPUT[4];
    N=INPUT[5];
    for (i=1;i<=cv;i++) {
	m[i]=INPUT[4*i+1+1]; 
	M[i]=INPUT[4*i+2+1]; 
	k[i]=INPUT[4*i+3+1]; 
	type[i]=INPUT[4*i+4+1];
    }
    for (i=1;i<=L;i++) {
	x0[i]=INPUT[4*(cv+1)+i+1];
	x1[i]=INPUT[4*(cv+1)+L+i+1];
    }
    for (i=1;i<=cv;i++) {
	if (type[i]) {
	    r=sqrt(x0[M[i]]*x0[M[i]]+x0[M[i]+1]*x0[M[i]+1]+x0[M[i]+2]*x0[M[i]+2]+x0[M[i]+3]*x0[M[i]+3])
	    x0[M[i]]/=r;x0[M[i]+1]/=r;x0[M[i]+2]/=r;x0[M[i]+3]/=r
	    r=sqrt(x1[M[i]]*x1[M[i]]+x1[M[i]+1]*x1[M[i]+1]+x1[M[i]+2]*x1[M[i]+2]+x1[M[i]+3]*x1[M[i]+3])
	    x1[M[i]]/=r;x1[M[i]+1]/=r;x1[M[i]+2]/=r;x1[M[i]+3]/=r
	}
    }
    for (i=1;i<=L;i++) {
	x[i]=x0[i];
    }
}
($1 !~ /#/ && NF==N) {
    U=0;W=0;t=$1;
    if (t<T) {
	for (i=1;i<=cv;i++){
	    if (type[i]) {
		q[1]=$(m[i]+1); Q[1]=x[M[i]]; Q1[1]=x1[M[i]];
		q[2]=$(m[i]+3); Q[2]=x[M[i]+1]; Q1[2]=x1[M[i]+1]; 
		q[3]=$(m[i]+5); Q[3]=x[M[i]+2]; Q1[3]=x1[M[i]+2];
		q[4]=$(m[i]+7); Q[4]=x[M[i]+3]; Q1[4]=x1[M[i]+3];
	    
		r=sqrt(q[1]*q[1]+q[2]*q[2]+q[3]*q[3]+q[4]*q[4]);
		q[1]/=r;q[2]/=r;q[3]/=r;q[4]/=r;
		R=sqrt(Q[1]*Q[1]+Q[2]*Q[2]+Q[3]*Q[3]+Q[4]*Q[4]);
		Q[1]/=R;Q[2]/=R;Q[3]/=R;Q[4]/=R;
		R1=sqrt(Q1[1]*Q1[1]+Q1[2]*Q1[2]+Q1[3]*Q1[3]+Q1[4]*Q1[4]);
		Q1[1]/=R1;Q1[2]/=R1;Q1[3]/=R1;Q1[4]/=R1;
	    
		co=q[1]*Q[1]+q[2]*Q[2]+q[3]*Q[3]+q[4]*Q[4];
		coo=co; if (co>1) {coo=1;} if (co<-1) {coo=-1;}
		omega=acos(coo);
		si=sin(omega);
		if (abs(si)>1e-8)
		    w[i]-=k[i]*(omega/si)*((q[1]-Q[1]*co)*(Q1[1]-Q[1])+(q[2]-Q[2]*co)*(Q1[2]-Q[2])+(q[3]-Q[3]*co)*(Q1[3]-Q[3])+(q[4]-Q[4]*co)*(Q1[4]-Q[4]))*dt*1.0/(T-t);
		    u[i]=0.5*k[i]*omega*omega;
	    } else {
		y=$(m[i]); Y=x[M[i]]; Y1=x1[M[i]];
		w[i]-=k[i]*(y-Y)*dt*(Y1-Y)*1.0/(T-t);
		u[i]=0.5*k[i]*(y-Y)*(y-Y);
	    }
	    W+=w[i];
	    U+=u[i];
	}
	printf "%d %f %f %f",t,W,U,W-U;
	for (i=1;i<=cv;i++){
	    printf " %f %f",w[i],u[i];
	}
	printf "\n";
	for (i=1;i<=L;i++){
	    x[i]+=(x1[i]-x[i])*dt*1.0/(T-t);
	}
    } else {
	for (i=1;i<=cv;i++){
	    if (type[i]) {
		q[1]=$(m[i]+1); Q[1]=x[M[i]];
		q[2]=$(m[i]+3); Q[2]=x[M[i]+1];
		q[3]=$(m[i]+5); Q[3]=x[M[i]+2];
		q[4]=$(m[i]+7); Q[4]=x[M[i]+3];
	    
		r=sqrt(q[1]*q[1]+q[2]*q[2]+q[3]*q[3]+q[4]*q[4]);
		q[1]/=r;q[2]/=r;q[3]/=r;q[4]/=r;
		R=sqrt(Q[1]*Q[1]+Q[2]*Q[2]+Q[3]*Q[3]+Q[4]*Q[4]);
		Q[1]/=R;Q[2]/=R;Q[3]/=R;Q[4]/=R;
		co=q[1]*Q[1]+q[2]*Q[2]+q[3]*Q[3]+q[4]*Q[4];
		coo=co; if (co>1) {coo=1;} if (co<-1) {coo=-1;}
		omega=acos(coo);
		u[i]=0.5*k[i]*omega*omega;
	    } else {
		y=$(m[i]); Y=x[M[i]];
		u[i]=0.5*k[i]*(y-Y)*(y-Y);
	    }
	    W+=w[i];
	    U+=u[i];
	}
	printf "%d %f %f %f",t,W,U,W-U;
	for (i=1;i<=cv;i++){
	    printf " %f %f",w[i],u[i];
	}
	printf "\n";
    }
}' $@
