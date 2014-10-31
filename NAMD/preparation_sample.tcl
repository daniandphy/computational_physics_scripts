package require psfgen
package require solvate
package require autoionize

#mol load psf catenin_A_273-635_deH_SMD2_wi.psf pdb catenin_A_273-635_deH_SMD_cv02.coor
#set pro [atomselect top protein]
#$pro writepdb catenin_A_273-635_deH_SMD_cv02.coor_protein.pdb
#mol delete all

mol load psf catenin_273-396_WT_autopsf.psf pdb catenin_273-396_WT_autopsf.pdb
set pro2 [atomselect top all]
set MM [measure minmax $pro2]
set minex {-15 -15 -15} 
set maxex {15 15 15}
set mima [list [vecadd [lindex $MM 0] $minex] [vecadd [lindex $MM 1] $maxex]]
#set mima [vecadd $MM $ext]
mol delete all

solvate catenin_273-396_WT_autopsf.psf catenin_273-396_WT_autopsf.pdb -o catenin_273-396_WT_w -b 1.5 -minmax $mima
mol delete all

autoionize -psf catenin_273-396_WT_w.psf -pdb catenin_273-396_WT_w.pdb -sc 0.15 -o catenin_273-396_WT_wi
mol delete all

mol load psf catenin_273-396_WT_wi.psf pdb catenin_273-396_WT_wi.pdb
set all [atomselect top all]
set nCa [atomselect top "protein and name CA and not resid 274 275"]
set nO [atomselect top "protein and name O and resid 274"]
$all set beta 0
#$all set occupancy 0
$nCa set beta 1
$nO set beta 1
$all writepdb notsidechainsfix.pdb
set MM2 [measure minmax $all]
set pb [vecsub [lindex $MM2 1] [lindex $MM2 0]]
measure center $all


exit



 

