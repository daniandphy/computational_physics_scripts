# align frames in trajectory and wrap atoms into a single unitcell using the protein as the center.
#set name [gets stdin]
set name "namexxx"
set PSF  "psfxxx"
set ALL_DCDS "all_dcdsxxx"
package require pbctools

#mol load psf ../build/step5_assembly.xplor_ext.psf pdb ../build/step5_assembly.pdb
set mol [mol new $PSF type psf]
set all_dcds [lsort -dictionary [glob $ALL_DCDS]]
set nfiles [llength $all_dcds]
for {set i 0} {$i < $nfiles} {incr i} {
	puts "addfile [lindex $all_dcds $i]  type dcd first 0 last -1 step 10 filebonds 1 autobonds 1 waitfor all"
	mol addfile [lindex $all_dcds $i]  type dcd first 0 last -1 step 50 filebonds 1 autobonds 1 waitfor all
}

pbc wrap -compound res -center com -centersel "protein" -all

set n [molinfo top get numframes]
#set frame0 [atomselect top "protein and backbone and noh" frame 0]
#set frameC [atomselect top "protein and backbone and noh"]
set all [atomselect top all]
set pro [atomselect top protein]

animate write dcd all_traj_$name.dcd waitfor all top

exit
