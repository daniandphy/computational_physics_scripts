#!/bin/bash

#qsub -pe linux_smp_short 48-64 -N ene_recal -j y -o ~/Jobs -cwd  energy_recalculation_wrapper.sh

cd "$PWD"

source_folder="/home/danial/script/namd_scripts/FEP/fep/tools"
#############claculating unresrtraint energies


start=0.0
end=1.0
step=0.03125
win_step=1000

win=`echo $start`
> all_energies_fwd.out
> all_energies_bwd.out

#####find the number of needed lines if the dcd files are more than one file
grep "ENERGY:" temp_fwd_${win}.log| grep  -v  "Info:" | awk '{print $14}' > temp_file
NUMofLINES=$(wc -l < "temp_file")
LEFTOVER=$(($NUMofLINES%$win_step))
NEEDEDLINES_fwd=$(($NUMofLINES-$LEFTOVER))
#echo "$NUMofLINES $LEFTOVER $NEEDEDLINES_fwd"

grep "ENERGY:" temp_bwd_${win}.log| grep  -v  "Info:" | awk '{print $14}' > temp_file
NUMofLINES=$(wc -l < "temp_file")
LEFTOVER=$(($NUMofLINES%$win_step))
NEEDEDLINES_bwd=$(($NUMofLINES-$LEFTOVER))


########################################################################

if [ -a ../fep/*fwd*cont.dcd ];then
	touch all_energies_fwd_cont.out
	touch all_energies_fwd_rest_cont.out
fi
###
if [ -a ../fep/*bwd*cont.dcd ];then
	touch all_energies_bwd_cont.out
	touch all_energies_bwd_rest_cont.out
fi
#######################################################################################################################################################
while [ $(echo " $win <= $end" | bc) -eq 1 ]; do
	
	echo $win
	#echo ""ENERGY:" temp_fwd_${win}.log| grep  -v  "Info:" | awk '{print $14}' |head -n $NEEDEDLINES_fwd > temp_file"
	grep "ENERGY:" temp_fwd_${win}.log| grep  -v  "Info:" | awk '{print $14}' |head -n $NEEDEDLINES_fwd > temp_file
	paste all_energies_fwd.out temp_file >temp_file2
	mv temp_file2 all_energies_fwd.out 
	
	echo $win
	grep "ENERGY:" temp_bwd_${win}.log| grep  -v  "Info:" | awk '{print $14}' |head -n $NEEDEDLINES_bwd > temp_file
	paste all_energies_bwd.out temp_file >temp_file2
	mv temp_file2 all_energies_bwd.out 
	
	
	if [ -a ../fep/*fwd*cont.dcd ];then
		grep "ENERGY:" temp_fwd_${win}_cont.log| grep  -v  "Info:" | awk '{print $14}' > temp_file
		paste all_energies_fwd_cont.out temp_file >temp_file2
		mv temp_file2 all_energies_fwd_cont.out 
	fi
	if [ -a ../fep/*bwd*cont.dcd ];then
		grep "ENERGY:" temp_bwd_${win}_cont.log| grep  -v  "Info:" | awk '{print $14}' > temp_file
		paste all_energies_bwd_cont.out temp_file >temp_file2
		mv temp_file2 all_energies_bwd_cont.out 
	fi
	win=$(echo  "$win+$step"|bc -l)
done
#rm temp_file temp_file2
#############claculating restaint energies
win=0.0


grep "ENERGY:" temp_fwd_rest.log| grep  -v  "Info:" | awk '{print $10}' |head -n $NEEDEDLINES_fwd > all_energies_fwd_rest.out


grep "ENERGY:" temp_bwd_rest.log| grep  -v  "Info:" | awk '{print $10}' |head -n $NEEDEDLINES_bwd > all_energies_bwd_rest.out




if [ -a ../fep/*fwd*cont.dcd ];then
		grep "ENERGY:" temp_fwd_rest_cont.log| grep  -v  "Info:" | awk '{print $10}' > all_energies_fwd_rest_cont.out 		
fi

if [ -a ../fep/*bwd*cont.dcd ];then
		grep "ENERGY:" temp_bwd_rest_cont.log| grep  -v  "Info:" | awk '{print $10}' > all_energies_bwd_rest_cont.out 
fi


##################################merging files
if [ -a ../fep/*fwd*cont.dcd ];then
cat all_energies_fwd_cont.out >>all_energies_fwd.out
cat all_energies_fwd_rest_cont.out >>all_energies_fwd_rest.out
fi

if [ -a ../fep/*bwd*cont.dcd ];then
cat all_energies_bwd_cont.out >>all_energies_bwd.out
cat all_energies_bwd_rest_cont.out >>all_energies_bwd_rest.out
fi


