#!/bin/bash

###idea from:http://gene.bio.jhu.edu/charmmscripts/efixpdb.awk
pdb=4m48_oriented_wild_apo_108snap.pdb

vmd64 -dispdev text -e segments.tcl >log

awk -f renumbering_pdb.awk chainID=T <TIP3T.pdb >TIP3T_renum.pdb
awk -f renumbering_pdb.awk chainID=U <TIP3U.pdb >TIP3U_renum.pdb

#vmd64 -dispdev text -e final-wt.tcl >log2
