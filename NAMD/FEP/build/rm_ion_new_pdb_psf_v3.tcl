proc get_total_charge {{molid top} {sel all}} {
        puts "total charge of $sel in $molid is:"
	eval "vecadd [[atomselect $molid $sel] get charge]"
}

###read the selection and the name from name_and_selection.tcl
##set SEL in the file
source name_and_selection.tcl
puts "selection: $SEL"
puts "name: $name"
############################
set mid [mol load psf ../../build/step5_assembly.xplor_ext.psf pdb ../../build/all_ions_38_701_702_703_last_frame.pdb]
###set SEL "not ((resname SOD and resid 38 702) or (resname CLA and resid 703))"
set allbuttheoneion [atomselect top $SEL]
$allbuttheoneion writepsf del.psf
$allbuttheoneion writepdb del.pdb
package require autoionize

autoionize -psf del.psf -pdb del.pdb -neutralize -o $name
####this part is for correcting the wrong projections of waters in to the center by autoionize? 
set newwater [atomselect top "water"]
set oldwater [atomselect $mid "water and resid [$newwater get resid]"]


$newwater set {x y z} [$oldwater get {x y z}]

########
set all [atomselect top "all"]
$all writepdb $name.pdb


get_total_charge 
###############################################done with making pdb and psf
#######################make restraints

puts "making restraint files ..."
set final [mol load psf $name.psf pdb $name.pdb]
set all [atomselect $final "all"]
set restraint_prot  [atomselect $final "protein and noh"]
set restraint_backbone  [atomselect $final "protein and (name C CA N O)"]
$all set beta 0

for {set i 1} { $i < 6} {incr i} {  

$restraint_prot set beta [expr 12.0 / ($i+2.0)]
$restraint_backbone set beta [expr 12.0 / $i]

$all writepdb $name.$i.const

}

exit
