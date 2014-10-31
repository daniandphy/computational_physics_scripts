#################vector operations
 proc lmap {_var list body} {
     upvar 1 $_var var
     set res {}
     foreach var $list {lappend res [uplevel 1 $body]}
     set res
 }
#-- We need basic scalar operators from [expr] factored out:
 foreach op {+ - * / % ==} {proc $op {a b} "expr {\$a $op \$b}"}

proc vec {op a b} {
     if {[llength $a] == 1 && [llength $b] == 1} {
         $op $a $b
     } elseif {[llength $a]==1} {
         lmap i $b {vec $op $a $i}
     } elseif {[llength $b]==1} {
         lmap i $a {vec $op $i $b}
     } elseif {[llength $a] == [llength $b]} {
         set res {}
         foreach i $a j $b {lappend res [vec $op $i $j]}
         set res
     } else {error "length mismatch [llength $a] != [llength $b]"}
 }

###################end of vector operations

####main script
####This script dumps pdbs for a given snapshot list,it aslo write the center of mass of COM_SELECTION in "cpoint.out"
set PSF "psfxxx"
set DCD "dcdxxx"
set SNAPSHOT_LIST { snapshot_listxxx }
set PREFIX_NAME "prefix_namexxx"
set COM_SELECTION "com_selectionxxx"
mol load psf $PSF dcd $DCD

set SEL "protein"
set FIT_SEL "protein and noh"


set fit_ref [atomselect top $FIT_SEL]
set fit_sel [atomselect top $FIT_SEL]
set selection [atomselect top $SEL]
$fit_ref frame 0


puts "SNAPSHOT_LIST $SNAPSHOT_LIST"

set ave_com 0

foreach snapshot $SNAPSHOT_LIST {
$selection frame $snapshot
$fit_sel frame $snapshot

set transformation_mat [measure fit $fit_sel $fit_ref]
$selection move $transformation_mat

#[atomselect top $selection frame $snapshot] 
$selection writepdb $PREFIX_NAME.$snapshot.pdb

########
set com_sel [atomselect top  $COM_SELECTION]
$com_sel frame $snapshot
set com [measure center $com_sel]
set ave_com [vec +  $ave_com  $com]

}
set file_com_selection [open "cpoint.out" w]
set SNAPSHOT_LIST_len [llength $SNAPSHOT_LIST]
puts "center of hole: [vec / $ave_com $SNAPSHOT_LIST_len]"
puts $file_com_selection "[vec / $ave_com $SNAPSHOT_LIST_len]"

close $file_com_selection

exit


