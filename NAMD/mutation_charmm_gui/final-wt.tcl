
set out_name final_wt

package require psfgen

topology /home/paween/bin/toppar/top_all36_prot.rtf
topology /home/paween/bin/toppar/toppar_water_ions.0.str
topology /home/paween/bin/toppar/top_all36_lipid.rtf

segment A {
first NTER
last CTER
pdb PROA.pdb
}
coordpdb PROA.pdb A
patch GLUP A:84 
patch GLUP A:490 
patch ASPP A:420
regenerate angles dihedrals

segment M {
pdb MEMB.pdb
}
coordpdb MEMB.pdb M

segment WA {
pdb WATA.pdb
}
coordpdb WATA.pdb WA



segment T {
pdb TIP3T_renum.pdb 
}
coordpdb TIP3T_renum.pdb T

segment U {
pdb TIP3U_renum.pdb 
}
coordpdb TIP3U_renum.pdb U

segment PW {
pdb PWAT.pdb
}
coordpdb PWAT.pdb PW

segment NA {
pdb SOD.pdb
}
coordpdb SOD.pdb NA

segment CL {
pdb CLA.pdb 
} 
coordpdb CLA.pdb CL

guesscoord
regenerate angles
regenerate dihedrals 

writepdb $out_name.pdb 
writepsf $out_name.psf  
 
mol delete all
###################################################
proc get_total_charge {{molid top} {sel all}} {
        puts "total charge of $sel in $molid is:"
	eval "vecadd [[atomselect $molid $sel] get charge]"
}



mol load psf $out_name.psf pdb $out_name.pdb

set all [atomselect top all]
set w [atomselect top "water and noh"] 

measure center $all

measure minmax $w

get_total_charge 

quit 
 


