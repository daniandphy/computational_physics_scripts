#!/usr/local/bin/bash
stride=10 ###for protein_only.dcd
name="apo"
psf="..\/build\/step5_assembly.xplor_ext.psf"
all_dcds_bslash="..\/run\/step7\*.dcd"
pdb="..\/build\/step5_assembly.pdb"
ref_pdb="..\/build\/step5_assembly.pdb"

all_dcds=`ls ../run/*dcd |sort -n -t . -k 4`

echo $ref_pdb
echo $psf
############################################### saving protein_only trajectory
if [ ! -f make_indexfile.tcl ]; then
cp /home/danial/script/namd_scripts/general_analysis/make_indexfile.tcl ./
sed -i s/psfxxx/$psf/g make_indexfile.tcl
sed -i s/pdbxxx/${pdb}/g make_indexfile.tcl
fi


vmd64 -dispdev text -e make_indexfile.tcl


echo $all_dcds

#rm protein_only.dcd
#catdcd -o protein_only.dcd -stride $stride -i findexfile.ind $all_dcds
#################################################
if [ ! -f pbctools_wrap_translate_protein.tcl ]; then
cp /home/danial/script/namd_scripts/general_analysis/pbctools_wrap_translate_protein.tcl ./
sed -i s/namexxx/$name/g pbctools_wrap_translate_protein.tcl
sed -i s/psfxxx/$psf/g pbctools_wrap_translate_protein.tcl
sed -i s/all_dcdsxxx/${all_dcds_bslash}/g pbctools_wrap_translate_protein.tcl
fi

vmd64 -dispdev text -e pbctools_wrap_translate_protein.tcl
