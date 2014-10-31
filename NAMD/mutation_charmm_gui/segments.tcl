
mol load pdb 4m48_oriented_wild_apo_108snap.pdb 
set A [atomselect top "segid PROA"]
$A set chain A
$A writepdb PROA.pdb

set m [atomselect top "segid MEMB"]
$m set chain M
$m writepdb MEMB.pdb 

set WA [atomselect top "segid WATA"]
$WA set chain WA
$WA writepdb WATA.pdb

set PW [atomselect top "segid PWAT"]
$PW set chain PW
$PW writepdb PWAT.pdb

set starting_ind_TIP3 39714

set T [atomselect top "segid TIP3 and index < $starting_ind_TIP3 + 9998*3 "]
$T set chain T
$T set resid [$T get residue] 
$T writepdb TIP3T.pdb

set U [atomselect top "segid TIP3 and index > $starting_ind_TIP3 + 9998*3 -1"]
$U set chain U
$U set resid [$U get residue] 
$U writepdb TIP3U.pdb


set NA [atomselect top "segid SOD"]
$NA writepdb SOD.pdb

set CL [atomselect top "segid CLA"]
$CL writepdb CLA.pdb

quit      
