
set name "namexxx"
set PSF  "psfxxx"
set DCD  "dcdxxx"
set SEL1  "sel1xxx"
set SEL2  "sel2xxx"
set START "startxxx"
set STOP "stopxxx"
set STEP "stepxxx"

set mol [mol new $PSF type psf]
mol addfile  $DCD  type dcd first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all

set sel1 [atomselect $mol $SEL1]
set sel2 [atomselect $mol $SEL2]

##############################
 
if {$START == "startxxx"} {
set START 0
}
if {$STOP == "stopxxx" || $STOP == -1} {
set STOP [molinfo $mol get numframes]
}
if {$STEP == "stepxxx" || $STEP== ""} {
set STEP 1
}

#####################################

set outfile [open angle_${name}.out w]


set conv [expr 180.0 / acos(-1.0)]
for {set i $START} { $i <$STOP} {incr i $STEP} {
$sel1 frame $i
$sel2 frame $i

set vec1 [lindex [lindex [measure inertia $sel1] 1] 2]
set vec2 [lindex [lindex [measure inertia $sel2] 1] 2]
set vec1_mag [veclength $vec1]
set vec2_mag [veclength $vec2]
set dotp [vecdot $vec1 $vec2]
set theta [expr $conv * acos($dotp/($vec1_mag*$vec2_mag))]

puts $outfile $theta
}
close $outfile

exit
