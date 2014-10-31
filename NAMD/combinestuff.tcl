set completeid [mol load psf /Scr/danial/DAT/build/charmm-gui/step5_assembly.xplor_ext.psf pdb /Scr/danial/DAT/build/charmm-gui/step5_assembly.pdb]
set crystal [mol new 4m48]
set cholesterol [atomselect $crystal "resname CLR"]

[atomselect $crystal "all"] move [measure fit [atomselect $crystal "name CA and chain A and not resid 290"] [atomselect $completeid "name CA and not resid 290"] ]
puts [measure rmsd [atomselect $crystal "name CA and chain A and not resid 290"] [atomselect $completeid "name CA and not resid 290"] ]
$cholesterol set resname CHL1
$cholesterol set resid 1
$cholesterol writepdb cholesterol.pdb

package require psfgen
topology /home/danial/toppar/top_all36_cgenff.rtf
topology /home/danial/toppar/top_all36_lipid.rtf
topology /home/danial/toppar/stream/top_all36_cholesterol.top

segment KOL {
	residue 1 CHL1
	first none
	last none
}
coordpdb cholesterol.pdb KOL
regenerate angles dihedrals
guesscoord
writepdb chol.pdb
writepsf chol.psf

set cholmol [mol load psf chol.psf pdb chol.pdb]
set mol [::TopoTools::mergemols [list $cholmol  $completeid]]
animate write psf combined.psf $mol
animate write pdb combined.pdb $mol

