set name "namexxx"
set PSF "psfxxx"
set REF_FRAME "ref_framexxx"
set REF_PDB "ref_pdbxxx"
set DCD "dcdxxx"
set SEL "selxxx"
set FIT_SEL "sel_fitxxx"
set START "startxxx"
set STOP "stopxxx"
set STEP "stepxxx"

puts "rmsd selection: $SEL"
puts "fit selection:  $FIT_SEL"

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
$ref frame 0
} elseif { $REF_PDB == "ref_pdbxxx" } {
    if {$REF_FRAME < 0} { set REF_FRAME [expr $nf - 1]} 
##### i.e. choose total  number of avaiable frames
set fit_ref [atomselect $mol $FIT_SEL]
set ref [atomselect $mol $SEL]
$fit_ref frame $REF_FRAME
$ref frame $REF_FRAME
} else {
puts "ref pdb: $REF_PDB"
set mol_ref [mol new $REF_PDB type pdb]
set fit_ref [atomselect $mol_ref $FIT_SEL]
set ref [atomselect $mol_ref $SEL]

}
###### setting range frame for rmsd
if {$START == "startxxx"} {
set START 0
}
if {$STOP == "stopxxx" || $STOP == -1} {
set STOP [expr $nf - 1]
}
if {$STEP == "stepxxx" || $STEP == ""} {
set STEP 1
}
###############################################
set file_rmsd [open "rmsd_$name.dat" w]
#############
set selection [atomselect $mol $SEL]
set fit_selection [atomselect $mol $FIT_SEL]
puts "$START $STEP $STOP"
puts $file_rmsd "#frame\trmsd    psf:$PSF  dcd: $DCD"
for {set i $START} { $i <= $STOP} {incr i $STEP} {
	$selection frame $i
        $fit_selection frame $i
        set transformation_mat [measure fit $fit_selection $fit_ref]
	$selection move $transformation_mat
	puts $file_rmsd "$i\t[measure rmsd $selection $ref]"
}
close $file_rmsd
exit
