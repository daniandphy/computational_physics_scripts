source ~/script/namd_scripts/bigdcd.tcl
# align frames in trajectory and wrap atoms into a single unitcell using the protein as the center.
#set name [gets stdin]
set name "alligned"
set PSF  "../../build/4m48_wild_apo_Na1_popc.psf"
#set ALL_DCDS "../../fep_old/*.dcd"
set DCDDIR "../../fep"
set STEP 100

package require pbctools

#mol load psf ../build/step5_assembly.xplor_ext.psf pdb ../build/step5_assembly.pdb
puts all_traj_${name}_${STEP}.dcd

mol new $PSF type psf
#set all_dcds [lsort -dictionary [glob $ALL_DCDS]]
set all_dcds [list "$DCDDIR/FEP_fwd.dcd" "$DCDDIR/FEP_bwd.dcd"]
set nfiles [llength $all_dcds]
for {set i 0} {$i < $nfiles} {incr i} {
	puts "addfile [lindex $all_dcds $i]  type dcd first 0 last -1 step $STEP filebonds 1 autobonds 1 waitfor all"
	mol addfile [lindex $all_dcds $i]  type dcd first 0 last -1 step $STEP filebonds 1 autobonds 1 waitfor all
}

pbc wrap -compound res -center com -centersel "protein" -all

set n [molinfo top get numframes]
#set frame0 [atomselect top "protein and backbone and noh" frame 0]
#set frameC [atomselect top "protein and backbone and noh"]
set all [atomselect top all]
set pro [atomselect top protein]

for { set i 0 } {$i <= $n } { incr i } {
         $pro frame $i
	 $all frame $i
	 $all moveby [vecinvert [measure center $pro]]
}

animate write dcd all_traj_${name}_${STEP}.dcd waitfor all top


