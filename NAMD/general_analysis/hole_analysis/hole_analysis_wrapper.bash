#!/usr/local/bin/bash
## this script generates snapshot for a given snapshot list and run hole program for given the list and average the results


psf="..\/..\/build\/step5_assembly.xplor_ext.psf"
dcd="..\/all_traj_apo.dcd"
#com_selection="protein and (resid 420 421 45 42 417)"

com_selection="protein and (resid 325 44 320 385) and name CA"
############################################################
snapshot_list="500 550 600 650 700 750 800 850 900 950"  #;export snap_shot_list ###

prefix_name=""
rm $prefix_name.input.list
sed s/psfxxx/$psf/g   /home/danial/script/namd_scripts/general_analysis/hole_analysis/snapshot_maker.tcl > snapshot_maker.tcl
sed -i "s/dcdxxx/$dcd/g" snapshot_maker.tcl
sed -i "s/snapshot_listxxx/$snapshot_list/g" snapshot_maker.tcl
sed -i s/prefix_namexxx/$prefix_name/g snapshot_maker.tcl
sed -i "s/com_selectionxxx/$com_selection/g" snapshot_maker.tcl
vmd64 -dispdev text -e snapshot_maker.tcl
cpoint=`head -1 cpoint.out`

i=1
####
for snapshot in $snapshot_list; do
echo $i
pdb_name="${prefix_name}.${snapshot}.pdb"
hole_out_name_pref="${prefix_name}.${snapshot}.hole"
sed s/pdbxxx/$pdb_name/g  /home/danial/script/namd_scripts/general_analysis/hole_analysis/hole.inp > hole.inp
sed -i s/hole_outputxxx/$hole_out_name_pref/g hole.inp
sed -i "s/cpointxxx/$cpoint/g" hole.inp
hole < hole.inp > ${hole_out_name_pref}.out

#if [ $i -eq 1 ]
#then
grep "(mid-point)" ${hole_out_name_pref}.out |awk '{print $'1','\t',$'2'}' > ${prefix_name}.radius.$snapshot.out
#else
#grep "(mid-point)" ${hole_out_name_pref}.out |awk '{print $'1','\t',$'2'}' > temp
#paste ${prefix_name}.radius.all.out temp >temp2
#mv temp2 ${prefix_name}.radius.all.out 
#fi
i=$((i+1))
echo "${prefix_name}.radius.$snapshot.out" >> $prefix_name.input.list
done
python  ~/script/namd_scripts/general_analysis/hole_analysis/hole_mean_var.py -il $prefix_name.input.list -o ${prefix_name}.radius.all.out -omv ${prefix_name}.radius.mean_var.out

