source ~/script/namd_scripts/bigdcd.tcl
# align frames in trajectory and wrap atoms into a single unitcell using the protein as the center.
#set name [gets stdin]
set name "apo_chol_na3_nowat"
set PSF  "../build_1/4m48_wild_apo_cholesterol_popc_nowat_sod.psf"
set ALL_DCDS "../run_1/step7*.dcd"
set STEP 10
##change to if condition to, 1 if the long dcd doesn't already exist!!
if {0} {
package require pbctools

#mol load psf ../build/step5_assembly.xplor_ext.psf pdb ../build/step5_assembly.pdb
puts all_traj_${name}_${STEP}.dcd

mol new $PSF type psf
set all_dcds [lsort -dictionary [glob $ALL_DCDS]]
puts "all_dcds: $all_dcds"
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

}

########################################################################


proc mypermeation {frame} {
  global out water segList ridList labelList bigdcd_frame r_ave
  set upperEnd 12
  set lowerEnd -12
  set oldList $labelList
  set labelList {}
  set fr $bigdcd_frame
  
  foreach x [$water get x] y [$water get y] z [$water get z]  oldLab $oldList segname $segList resid $ridList {
    if {$z > $upperEnd} {
      set newLab 2
      set r_wat [expr sqrt(pow($x,2) + pow($y,2))]
      
      if {$oldLab == -1 && $r_wat < $r_ave} {
        puts $out "$segname:$resid permeated along +z direction at frame $fr"
            }

    } elseif {$z < $lowerEnd } {
      set newLab -2
      set r_wat [expr sqrt(pow($x,2) + pow($y,2))]

      if {$oldLab == 1 && $r_wat < $r_ave} {
        puts $out "$segname:$resid permeated along -z direction at frame $fr"
        }
    } elseif {abs($oldLab) > 1} {
      set newLab [expr $oldLab / 2]
    } else {
      set newLab $oldLab
    }
    lappend labelList $newLab
   }
   puts "finished with frame $frame"
}

mol load psf $PSF
animate read dcd all_traj_${name}_${STEP}.dcd beg 0 end 0 waitfor all
puts "OK up to here"
set out [open "permeation_long_${name}_${STEP}.dat" w]
puts  "output is permeation_long_${name}_${STEP}.dat"
#set labelfile [open labels.dat w]
set water [atomselect top "name OH2"]
set segList [$water get segname]
set ridList [$water get resid]
set labelList {}
set bigdcd_frame 0
foreach foo $segList {
  lappend labelList 0
}
####find the protein bondary
  set sel [atomselect top "protein"]
  set prot_minmax [measure minmax $sel]
  lassign [lindex $prot_minmax 0] lower_x lower_y lower_z  
  lassign [lindex $prot_minmax 1] upper_x upper_y upper_z
  set  r_ave [expr (($upper_x+$upper_y-$lower_x-$lower_y)/4) - 2.0]
  
  puts "lower_x lower_y upper_x upper_y: $lower_x $lower_y $upper_x $upper_y"
  puts "r_ave: $r_ave"
  ####

#bigdcd mypermeation mineq-aqp4-07-alignedCA.dcd mineq-aqp4-08-alignedCA.dcd mineq-aqp4-09-alignedCA.dcd mineq-aqp4-10-alignedCA.dcd mineq-aqp4-11-alignedCA.dcd mineq-aqp4-12-alignedCA.dcd mineq-aqp4-13-alignedCA.dcd  mineq-aqp4-14-alignedCA.dcd mineq-aqp4-15-alignedCA.dcd
#bigdcd mypermeation vSGLT_IF_661ns_aligned_wrap_comp.dcd 
bigdcd mypermeation  all_traj_${name}_${STEP}.dcd
#../run/step7.1_production.dcd ../run/step7.2_production.dcd

#exit
