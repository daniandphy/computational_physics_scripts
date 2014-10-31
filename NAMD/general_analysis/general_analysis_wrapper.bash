#!/usr/local/bin/bash
name="apo"
psf="..\/build\/step5_assembly.xplor_ext.psf"
dcd="all_traj_$name.dcd"

rg=0 ##radius of gyration
rmsd=1 ### run rmsd
rmsf=1 ### run rmsf
dist=0### misure distance betweeen com of two selections

start=0
stop=-1
step=10


########################################## radius of gyration
if [ $rg -eq 1 ]; then
rg_prefix=""

whole_name="${name}_${rg_prefix}"

rg_selection="protein and noh"
cp /home/danial/script/namd_scripts/general_analysis/radius_of_gyration.tcl ./
sed -i 0,/startxxx/{s/startxxx/$start/} radius_of_gyration.tcl ###replace only the first occurance
sed -i 0,/stopxxx/{s/stopxxx/$stop/} radius_of_gyration.tcl ###replace only the first occurance
sed -i 0,/stepxxx/{s/stepxxx/$step/} radius_of_gyration.tcl ###replace only the first occurance
sed -i s/namexxx/$whole_name/g radius_of_gyration.tcl
sed -i s/psfxxx/$psf/g radius_of_gyration.tcl
sed -i s/dcdxxx/$dcd/g radius_of_gyration.tcl
sed -i "s/selxxx/$rg_selection/g" radius_of_gyration.tcl

vmd64  -dispdev text -e radius_of_gyration.tcl
fi
############################################# RMSD

if [ $rmsd -eq 1 ]; then
rmsd_prefix="protein"
whole_name="${name}_${rmsd_prefix}"
fit_selection="protein and noh"
rmsd_selection="protein and name CA"
ref_pdb="..\/build\/step5_assembly.pdb"
cp /home/danial/script/namd_scripts/general_analysis/rmsd.tcl ./
sed -i 0,/startxxx/{s/startxxx/$start/} rmsd.tcl ###replace only the first occurance
sed -i 0,/stopxxx/{s/stopxxx/$stop/} rmsd.tcl ###replace only the first occurance
sed -i 0,/stepxxx/{s/stepxxx/$step/} rmsd.tcl ###replace only the first occurance
sed -i s/namexxx/$whole_name/g rmsd.tcl
sed -i s/psfxxx/$psf/g rmsd.tcl
sed -i s/dcdxxx/$dcd/g rmsd.tcl
sed -i "s/selxxx/$rmsd_selection/g" rmsd.tcl
sed -i "s/sel_fitxxx/$fit_selection/g" rmsd.tcl
#sed -i 0,/ref_pdbxxx/{s/ref_pdbxxx/${ref_pdb}/} rmsd.tcl
#sed -i 0,/ref_framexxx/{s/ref_framexxx/${ref_frame}/} rmsd.tcl
echo "fit_selection: $fit_selection"
vmd64  -dispdev text -e rmsd.tcl
fi

######################################## RMSF
if [ $rmsf -eq 1 ]; then
start=0
stop=-1
step=1
rmsf_prefix="BP"
whole_name="${name}_${rmsf_prefix}"
rmsf_selection="protein and noh and (resid 46 49 352 320 44 316 69 356 420 421 42 45 417)"
###alignment
fit_selection="name CA"
ref_pdb="..\/build\/step5_assembly.pdb"
####
cp /home/danial/script/namd_scripts/general_analysis/rmsf.tcl ./
sed -i 0,/startxxx/{s/startxxx/$start/} rmsf.tcl ###replace only the first occurance
sed -i 0,/stopxxx/{s/stopxxx/$stop/} rmsf.tcl ###replace only the first occurance
sed -i 0,/stepxxx/{s/stepxxx/$step/} rmsf.tcl ###replace only the first occurance
sed -i s/namexxx/$whole_name/g rmsf.tcl
sed -i s/psfxxx/$psf/g rmsf.tcl
sed -i s/dcdxxx/$dcd/g rmsf.tcl
sed -i "s/selxxx/$rmsf_selection/g" rmsf.tcl
###alignment
sed -i "s/sel_fitxxx/$fit_selection/g" rmsf.tcl
sed -i 0,/ref_pdbxxx/{s/ref_pdbxxx/${ref_pdb}/} rmsf.tcl

vmd64  -dispdev text -e rmsf.tcl
fi

######################################## RMSF
if [ $dist -eq 1 ]; then
start=0
stop=-1
step=1
dist_prefix="chol_BS"
whole_name="${name}_${dist_prefix}"
##sel1="protein and (resid 270 280 358 351 347) and noh"
###sel2="resname CHL1"
cp /home/danial/script/namd_scripts/general_analysis/distance.tcl ./
sed -i 0,/startxxx/{s/startxxx/$start/} distance.tcl ###replace only the first occurance
sed -i 0,/stopxxx/{s/stopxxx/$stop/} distance.tcl ###replace only the first occurance
sed -i 0,/stepxxx/{s/stepxxx/$step/} distance.tcl ###replace only the first occurance
sed -i s/namexxx/$whole_name/g distance.tcl
sed -i s/psfxxx/$psf/g distance.tcl
sed -i s/dcdxxx/$dcd/g distance.tcl
sed -i "s/sel1xxx/$sel1/g" distance.tcl
sed -i "s/sel2xxx/$sel2/g" distance.tcl

vmd64  -dispdev text -e distance.tcl
fi
