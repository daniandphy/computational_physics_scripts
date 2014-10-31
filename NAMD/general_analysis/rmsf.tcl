set name "namexxx"
set PSF "psfxxx"

set DCD "dcdxxx"
set SEL "selxxx"

set START "startxxx"
set STOP "stopxxx"
set STEP "stepxxx"
#####alignment
set FIT_SEL "sel_fitxxx"
set REF_FRAME "ref_framexxx"
set REF_PDB "ref_pdbxxx"
#####
puts "rmsf selection: $SEL"
set mol [mol new $PSF type psf]
mol addfile $DCD type dcd first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
#####
set nf [molinfo $mol get numframes]
####selecting reference based on pdb or frame number
if { $REF_FRAME == "ref_framexxx" && $REF_PDB == "ref_pdbxxx" } {
puts "warning: no reference is chosen, first frame choose as a default !!!"
set fit_ref [atomselect $mol $FIT_SEL]
set ref [atomselect $mol $SEL]
$fit_ref frame 0

} elseif { $REF_PDB == "ref_pdbxxx" &&  $REF_FRAME > -1 } {
    if {$REF_FRAME == -1} { set $REF_FRAME $nf}  #####choose total  number of avaiable frames
set fit_ref [atomselect $mol $FIT_SEL]
$fit_ref frame $REF_FRAME

} else {
puts "ref pdb: $REF_PDB"
set mol_ref [mol new $REF_PDB type pdb]
set fit_ref [atomselect $mol_ref $FIT_SEL]


}
###### setting range frame for rmsf
if {$START == "startxxx"} {
set START 0
}
if {$STOP == "stopxxx" || $STOP == -1} {
set STOP [expr $nf - 1]
}
if {$STEP == "stepxxx" || $STEP == ""} {
set STEP 1
}
puts "$START $STEP $STOP"
###############################################
set file_rmsf [open "rmsf_$name.dat" w]
#############

puts "resname selection: [string map {"protein" "name CA and protein"} $SEL]"
###select only each resname once
set SEL_RES_NAME [atomselect $mol [string map {"protein" "name CA and protein"} $SEL]] 


set selection_resname [$SEL_RES_NAME get resname]
set selection_resid [$SEL_RES_NAME get resid]
set selection_resname_len [llength $selection_resid]
######alignment ?
set selection [atomselect $mol $SEL]
set fit_selection [atomselect $mol $FIT_SEL]
for {set i $START} { $i <= $STOP} {incr i $STEP} {
	$selection frame $i
        $fit_selection frame $i
        set transformation_mat [measure fit $fit_selection $fit_ref]
	$selection move $transformation_mat
}
#######RMSF
for {set j 0} { $j < $selection_resname_len } { incr j} {
	set resname [lindex $selection_resname $j]
        set resid [lindex $selection_resid $j]
        set res [atomselect $mol "protein and noh and resid $resid"]
	set ind [$res get index]
	set tot_rmsf 0
	set tot_mass 0
	foreach index $ind {
		set atom [atomselect $mol "index $index"]
		set rmsf [measure rmsf $atom first $START last $STOP step $STEP]
		puts "$resid $rmsf $index"
		set mass [$atom get mass]
		set tot_rmsf [expr $tot_rmsf+$rmsf*$rmsf*$mass]
		set tot_mass [expr $tot_mass+$mass]
	}
	set rmsfperres [expr sqrt($tot_rmsf/$tot_mass)]
	puts $file_rmsf  "$resid $resname $rmsfperres"

}
close $file_rmsf

exit
