source ../build/name_and_selection.tcl

set mol [mol load psf ../build/$name.psf pdb ../build/$name.pdb]

set all  [atomselect $mol "all"]
$all set beta 0
set vanish  [atomselect $mol "$ion"]
$vanish set beta -1
$all writepdb $name.fep.pdb


#################get the atom serials for binding pocket and ion 
set outfile [open $name.colvar.in w]


set ion_pocket_sel [atomselect $mol $pocket]
set ion_sel [atomselect $mol $ion]

set ion_serial [$ion_sel get serial]
set pocket_serial [$ion_pocket_sel get serial]
##### write colvar
puts $outfile "colvarsTrajFrequency 10.0"
puts $outfile "colvarsRestartFrequency 100.0"
foreach serial $pocket_serial { 
puts $outfile "colvar  {"
puts $outfile "name $serial"
puts $outfile "        distance {"
puts $outfile "         group1 {"
puts $outfile "              atomnumbers { $ion_serial}"
puts $outfile "                }"
puts $outfile "         group2 {"
puts $outfile "                atomnumbers { $serial}"
puts $outfile "                }"
puts $outfile "        }"
puts $outfile "}"
puts $outfile ""
}

puts $outfile "harmonic {"
puts $outfile "colvars $pocket_serial"
puts $outfile "centers $centers"
puts $outfile "forceConstant $force_constants"
puts $outfile "}"
#puts $outfile "set ion_serial $ion_serial"
#puts $outfile "set pocket_serial \"$pocket_serial\""
close $outfile

puts "all done!!"
#################################
exit
