set name "namexxx"
set PSF "psfxxx"

set DCD "dcdxxx"
set SEL "selxxx"
set START "startxxx"
set STOP "stopxxx"
set STEP "stepxxx"


set mol [mol new $PSF type psf]
mol addfile $DCD type dcd first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all

###########################

proc center_of_mass {sel} {
        # some error checking
        if {[$sel num] <= 0} {
                error "center_of_mass: needs a selection with atoms"
        }
        # set the center of mass to 0
        set com [veczero]
        # set the total mass to 0
        set mass 0
        # [$selection get {x y z}] returns the coordinates {x y z}
        # [$selection get {mass}] returns the masses
        # so the following says "for each pair of {coordinates} and masses,
        #  do the computation ..."
        foreach coord [$sel get {x y z}] m [$sel get mass] {
           # sum of the masses
           set mass [expr $mass + $m]
           # sum up the product of mass and coordinate
           set com [vecadd $com [vecscale $m $coord]]
        }
        # and scale by the inverse of the number of atoms
        if {$mass == 0} {
                error "center_of_mass: total mass is zero"
        }
        # The "1.0" can't be "1", since otherwise integer division is done
        return [vecscale [expr 1.0/$mass] $com]
}



proc gyr_radius {sel} {
  # make sure this is a proper selection and has atoms
  
  if {[$sel num] <= 0} {
    error "gyr_radius: must have at least one atom in selection"
  }
  # gyration is sqrt( sum((r(i) - r(center_of_mass))^2) / N)
  set com [center_of_mass $sel]
  set sum 0
  #puts "gyr_radius $sel"
  foreach coord [$sel get {x y z}] {
    set sum [vecadd $sum [veclength2 [vecsub $coord $com]]]
  }
  return [expr sqrt($sum / ([$sel num] + 0.0))]
}


##############################

set file_rg [open "rg_$name.dat" w]
set selection [atomselect $mol $SEL]
 
if {$START == "startxxx"} {
set START 0
}
if {$STOP == "stopxxx" || $STOP == -1} {
set STOP [molinfo $mol get numframes]
}
if {$STEP == "stepxxx" || $STEP== ""} {
set STEP 1
}
# rmsd calculation loop

puts "$START $STEP $STOP"
puts $file_rg "#frame\tradius of gyration    psf:$PSF  dcd: $DCD"
for {set i $START} { $i < $STOP} {incr i $STEP} {
	$selection frame $i
	puts "frame $i"
	puts $file_rg "$i\t[gyr_radius $selection]"
}

exit
