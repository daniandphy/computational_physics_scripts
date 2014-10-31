###This script write a pdb and psf of the protein only from original pdb psf  files. that is why the first value in RMSD is not zero !!!!!

set PSF "psfxxx"
set PDB  "pdbxxx"

package require psfgen

topology /home/danial/toppar/top_all36_cgenff.rtf
topology /home/danial/toppar/top_all36_lipid.rtf
topology /home/danial/toppar/stream/top_all36_cholesterol.top



set newpsf "protein"

#readpsf ../build/step5_assembly.xplor_ext.psf
#coordpdb ../build/step5_assembly.pdb

mol new psf $PSF pdb $PDB

 

set all [atomselect top "all"]
#puts "$all num"

set sel1 [atomselect top "protein"]

#set sel2 [atomselect top “not [$sel1 text]”]
set sel2 [atomselect top not protein]
 

set indices [$sel1 get index]

 

set file [open findexfile.ind w]

#foreach I $indices {

#            puts $file $i


#}

puts $file $indices 

flush $file

close $file


#foreach segid [$sel2 get segid] [$sel2 get resid] atomname [$sel2 get name]
#{

#            delatom $segid $resid $atomname

#}

 

$sel1 writepsf $newpsf.psf
$sel1 writepdb ref.pdb
exit 
