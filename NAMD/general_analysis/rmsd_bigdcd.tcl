source ~/script/namd_scripts/bigdcd.tcl
proc myrmsd { frame } {
  global file_rmsd_CA file_rmsd_BP file_rmsf_CA file_rmsf_BP ref_CA sel_CA sel_BP ref_BP all
  $all move [measure fit $sel_CA $ref_CA]
  puts $file_rmsd_CA "$frame: [measure rmsd $sel_CA $ref_CA]"
  puts $file_rmsd_BP "$frame: [measure rmsd $sel_BP $ref_BP]"
  puts $file_rmsf_CA "$frame: [measure rmsf $sel_CA ]"
  puts $file_rmsf_BP "$frame: [measure rmsf $sel_BP ]"

  # puts $frame
}

set file_rmsd_CA [open "rmsd_CA_apo.dat" w]
set file_rmsd_BP [open "rmsd_BP_apo.dat" w]
set file_rmsf_CA [open "rmsf_CA_apo.dat" w]
set file_rmsf_BP [open "rmsf_BP_apo.dat" w]

set mol_ref [mol new /Scr/danial/DAT/apo/build/step5_assembly.pdb type pdb] 
set mol [mol new /Scr/danial/DAT/apo/build/step5_assembly.xplor_ext.psf type psf]
set all [atomselect $mol all]
set ref_CA [atomselect $mol_ref "name CA" ]
set sel_CA [atomselect $mol "name CA"]
set ref_BP [atomselect $mol_ref "protein and (resid 46 or resid 49 or resid 352 or resid 320 or resid 44 or resid 316 or resid 69 or resid 356 or resid 420 or resid 421 or resid 42 or resid 45 or resid 417)"]
set sel_BP [atomselect $mol "protein and (resid 46 or resid 49 or resid 352 or resid 320 or resid 44 or resid 316 or resid 69 or resid 356 or resid 420 or resid 421 or resid 42 or resid 45 or resid 417)"]

#mol addfile ../run/step7.1_production.dcd type dcd waitfor all
#set ls_cmd "ls  /Scr/danial/DAT/apo/run/"
set all_dcds_temp [glob ../run/step7*.dcd]
set all_dcds_1 [lsort -increasing $all_dcds_temp]
#put "asdfgagadgadgasdg [$all_dcds_temp is list]"
#set all_dcds [join $all_dcds_1]
set all_dcds [regexp -all -inline {\S+} $all_dcds_1]
put $all_dcds
bigdcd myrmsd dcd ../run/step7.1_production.dcd ../run/step7.2_production.dcd
bigdcd_wait
close $file_rmsd_CA
close $file_rmsd_BP
