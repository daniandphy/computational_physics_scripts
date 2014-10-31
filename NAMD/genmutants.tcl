package require psfgen
package require topotools
set original [mol load psf threesod.psf pdb threesod.pdb]
[atomselect $original "segname P1"] writepdb P1.pdb
[atomselect $original "segname P2"] writepdb P2.pdb
resetpsf
topology /home/josh/toppar/top_all36_prot.rtf
foreach mut [list LEU ALA LYS] {
	resetpsf
	foreach pdb [list P1 P2] {
		segment $pdb {
			pdb $pdb.pdb
			mutate 203 $mut
		}
		coordpdb $pdb.pdb $pdb
	}
	regenerate angles dihedrals
	guesscoord
	writepdb mutant.pdb
	writepsf mutant.psf
	set mutant [mol load psf mutant.psf pdb mutant.pdb]
	set mol [::TopoTools::selections2mol [list [atomselect $mutant "all"] [atomselect $original "not segname P1 P2"]]]
	animate write psf ASN203$mut.psf $mol
	animate write pdb ASN203$mut.pdb $mol
}

