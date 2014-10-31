#!/bin/bash

# extract the XNNN-XNNN distances from the dcd file
#vmd64 -dispdev text -e dist.tcl 2> dist.tst

# calculate the work profiles from the colvar trajectories
../../works.sh < ../input/colvars.conf smd.colvars.traj > works.txt

# combine the work profile with the distances
cat works.txt | awk '$1%2500==0{print $1,$2,$3,$4}' | head -2000 | \
paste /dev/stdin dist.txt > all.txt

# make a plot
gnuplot << EOF

set size 1, 1.2
set terminal postscript eps solid color enhanced lw 2.0 "Times-Roman" 36

set output "fig.ps"

set encoding iso_8859_1

set multiplot

set origin 0,0

set ylabel "Work (kcal/mol)" font "Times-Bold,42"
set ytics 0,50
set yrange [0:400]
set xlabel "distance (\305)" font "Times-Bold,42"

plot "all.txt" u 6:4 w l lt 1 t "transfered work"

set origin 0.8,0
set format y " "
set ylabel " "
set xlabel "t (ns)" font "Times-Bold,42"

plot "all.txt" u (\$1*0.000002):2 w l lt 3 lw 3 t "accumulated work", \
"all.txt" u (\$1*0.000002):4 w l lt 1 t "transfered work"

EOF

# convert to pdf
ps2epsi fig.ps
epstopdf fig.epsi
rm fig.ps fig.epsi

