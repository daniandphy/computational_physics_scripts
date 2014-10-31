set file [open rmsfperres_0.6us.dat a]

for {set i 8} { $i<=470 } {incr i} {
	set res [atomselect top "protein and resid $i and noh"]
	set ind [$res get index]
	set tot_rmsf 0
	set tot_mass 0
	foreach index $ind {
		set atom [atomselect top "index $index"]
		set rmsf [measure rmsf $atom]
		set mass [$atom get mass]
		set tot_rmsf [expr $tot_rmsf+$rmsf*$rmsf*$mass]
		set tot_mass [expr $tot_mass+$mass]
	}
	set rmsfperres [expr sqrt($tot_rmsf/$tot_mass)]
	puts $file "$i $rmsfperres"
	$res set beta $rmsfperres
}

close $file
