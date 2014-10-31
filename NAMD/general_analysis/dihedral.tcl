set name "Butane"
set PSF  "../build/Butane.psf"
set DCD  "step7.1_production.dcd"
set SEL  "name C1 C2 C3 C4"
set outfile [open Butane_dihedral.out w]

set mol [mol new $PSF type psf]
mol addfile  $DCD  type dcd first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all

set sel [atomselect $mol $SEL]
set sel_index [$sel get index]

set START 0
set STOP [molinfo $mol get numframes]

for {set i $START} { $i <$STOP} {incr i} {

puts $outfile [measure dihed $sel_index frame $i ]

}

exit
