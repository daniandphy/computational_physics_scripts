proc get_total_charge {{molid top} {sel all}} {
        puts "total charge of $sel in $molid is:"
	eval "vecadd [[atomselect $molid $sel] get charge]"
}
set mid [mol load psf ../../build/step5_assembly.xplor_ext.psf pdb ../../build/all_ions_38_701_702_703_last_frame.pdb]

set allbuttheoneion [atomselect top "not ((resname SOD and resid 38 702) or (resname CLA and resid 703))"]
$allbuttheoneion writepsf del.psf
$allbuttheoneion writepdb del.pdb

autoionize -psf del.psf -pdb del.pdb -neutralize -o testion

set newwater [atomselect top "water"]
set oldwater [atomselect $mid "water and resid [$newwater get resid]"]
puts "top: $top"
puts "mid: $mid"

$newwater set {x y z} [$oldwater get {x y z}]
set all [atomselect top "all"]
$all writepdb testion.pdb

