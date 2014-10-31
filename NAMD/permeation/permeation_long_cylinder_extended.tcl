proc mypermeation {frame} {
  global out water segList ridList labelList bigdcd_frame
  set upperEnd 12
  set lowerEnd -12
  set oldList $labelList
  set labelList {}
  set fr $bigdcd_frame

  foreach z [$water get z] x [$water get x] y [$water get y] oldLab $oldList segname $segList resid $ridList {
    if {$z > $upperEnd} {
      set newLab 2
      if {$oldLab == -1} {
        puts $out "$segname:$resid permeated along +z direction at frame $fr"
            }

    } elseif {$z < $lowerEnd} {
      set newLab -2
      if {$oldLab == 1} {
        puts $out "$segname:$resid permeated along -z direction at frame $fr"
        }
    } elseif {[expr $x*$x+$y*$y] < 400} { 
        if {abs($oldLab) > 1} {
          set newLab [expr $oldLab / 2]
        } else {
          set newLab $oldLab
        }
    } else {
       set newLab 0
    }
    lappend labelList $newLab
   }
   puts "finished with frame $frame"
}
source ~/scripts/bigdcd/bigdcd.tcl
mol load psf Mhp1_OF_popewi.psf
animate read dcd mhOF_83ns-10_wrap_trans.dcd beg 0 end 0 waitfor all

set out [open mhOF_permeation_long_cylinder_400_extended.dat w]
#set labelfile [open labels.dat w]
set water [atomselect top "name OH2"]
set segList [$water get segname]
set ridList [$water get resid]
set labelList {}
set bigdcd_frame 0
foreach foo $segList {
  lappend labelList 0
}

#bigdcd mypermeation mineq-aqp4-07-alignedCA.dcd mineq-aqp4-08-alignedCA.dcd mineq-aqp4-09-alignedCA.dcd mineq-aqp4-10-alignedCA.dcd mineq-aqp4-11-alignedCA.dcd mineq-aqp4-12-alignedCA.dcd mineq-aqp4-13-alignedCA.dcd  mineq-aqp4-14-alignedCA.dcd mineq-aqp4-15-alignedCA.dcd
#bigdcd mypermeation vSGLT_IF_661ns_aligned_wrap_trans.dcd 
#bigdcd mypermeation vSI2_165-247ns-10_wrap_trans.dcd vSI2_909-991ns-10_wrap_trans.dcd
bigdcd mypermeation mhOF_83ns-10_wrap_trans.dcd mhOF_84-167ns-10_wrap_trans.dcd mhOF_167-249ns-10_wrap_trans.dcd mhOF_250-332ns-10_wrap_trans.dcd mhOF_332-415ns-10_wrap_trans.dcd mhOF_416-498ns-10_wrap_trans.dcd mhOF_498-581ns-10_wrap_trans.dcd mhOF_582-664ns-10_wrap_trans.dcd mhOF_665-748ns-10_wrap_trans.dcd mhOF_748-831ns-10_wrap_trans.dcd mhOF_832-913ns-10_wrap_trans.dcd mhOF_913-997ns-10_wrap_trans.dcd mhOF_997-1080ns-10_wrap_trans.dcd mhOF_1081-1163ns-10_wrap_trans.dcd mhOF_1164-1247ns-10_wrap_trans.dcd
#bigdcd mypermeation vSI2_83ns-10_wrap_trans.dcd vSI2_82-165ns-10_wrap_trans.dcd vSI2_165-247ns-10_wrap_trans.dcd vSI2_247-330ns-10_wrap_trans.dcd vSI2_330-413ns-10_wrap_trans.dcd vSI2_413-495ns-10_wrap_trans.dcd vSI2_495-578ns-10_wrap_trans.dcd vSI2_578-661ns-10_wrap_trans.dcd vSI2_661-743ns-10_wrap_trans.dcd vSI2_744-826ns-10_wrap_trans.dcd vSI2_827-909ns-10_wrap_trans.dcd vSI2_909-991ns-10_wrap_trans.dcd vSI2_992-1074ns-10_wrap_trans.dcd vSI2_1074-1156ns-10_wrap_trans.dcd 
#../vSGLTGALps-01.dcd ../vSGLTGALps-02.dcd ../vSGLTGALps-03.dcd ../vSGLTGALps-04.dcd ../vSGLTGALps-05.dcd ../vSGLTGALps-06.dcd ../vSGLTGALps-07.dcd ../vSGLTGALps-08.dcd ../vSGLTGALps-09.dcd ../vSGLTGALps-10.dcd ../vSGLTGALps-11.dcd ../vSGLTGALps-12.dcd ../vSGLTGALps-13.dcd ../vSGLTGALps-14.dcd ../vSGLTGALps-15.dcd ../vSGLTGALps-16.dcd ../vSGLTGALps-17.dcd ../vSGLTGALps-18.dcd ../vSGLTGALps-19.dcd 

#WT1:1267 permeated along -z direction at frame 7295
#WT1:6074 permeated along -z direction at frame 7375
#NW3:6519 permeated along -z direction at frame 8189
#WT2:5840 permeated along -z direction at frame 8219
#NW1:5446 permeated along +z direction at frame 8424
