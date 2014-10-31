mol new 2I68
set sel [atomselect top "chain A and resid 4 to 25"]
$sel writepdb 2L68chainA_1.pdb
set sel [atomselect top "chain B and resid 4 to 25"]
$sel writepdb 2L68chainB_1.pdb
set sel [atomselect top "chain B and resid 31 to 55"]
$sel writepdb 2L68chainB_2.pdb
set sel [atomselect top "chain A and resid 31 to 55"]
$sel writepdb 2L68chainA_2.pdb
set sel [atomselect top "chain A and resid 57 to 84"]
$sel writepdb 2L68chainA_3.pdb
set sel [atomselect top "chain B and resid 57 to 84"]
$sel writepdb 2L68chainB_3.pdb
set sel [atomselect top "chain B and resid 84 to 110"]
$sel writepdb 2L68chainB_4.pdb
set sel [atomselect top "chain A and resid 84 to 110"]
$sel writepdb 2L68chainA_4.pdb
set sel [atomselect top "chain A"]
$sel writepdb chainA.pdb
set sel [atomselect top "chain B"]
$sel writepdb chainB.pdb

resetpsf
topology /home/josh/toppar/top_all36_prot.rtf
pdbalias residue HOH TIP3
pdbalias residue HIS HSE
#Seleno-methionine for methionine replacement.
pdbalias residue MSE MET
pdbalias atom MSE SE S
pdbalias atom ILE CD1 CD
pdbalias atom HOH O OH2
pdbalias residue NA SOD
pdbalias atom NA NA SOD
segment A {
residue 1 MET A
residue 2 ASN A
residue 3 PRO A
pdb 2L68chainA_1.pdb
residue 22 LYS A                                                    
residue 23 PHE A                                                    
residue 24 SER A                                                    
residue 25 GLU A                                                    
residue 26 GLY A                                                     
residue 27 PHE A                                                     
residue 28 THR A                                                     
residue 29 ARG A                                                   
residue 30 LEU A                                                    
residue 31 TRP A                                                    
residue 32 PRO A
residue 33 SER A
pdb 2L68chainA_2.pdb
residue 53 TYR A                                           
residue 54 ILE A                                      
residue 55 PRO A
residue 56 THR A
residue 57 GLY A
pdb 2L68chainA_3.pdb
residue 81 GLN A
residue 82 ARG A
residue 83 LEU A
residue 84 ASP A
residue 85 LEU A
residue 86 PRO A
pdb 2L68chainA_4.pdb
residue 105 SER A
residue 106 ARG A
residue 107 SER A                  
residue 108 THR A     
residue 109 PRO A                          
residue 110 HSE A
}
segment B {
residue 1 MET B
residue 2 ASN B
residue 3 PRO B
pdb 2L68chainB_1.pdb
residue 22 LYS B                                                    
residue 23 PHE B                                                    
residue 24 SER B                                                    
residue 25 GLU B                                                    
residue 26 GLY B                                                     
residue 27 PHE B                                                     
residue 28 THR B                                                     
residue 29 ARG B                                                   
residue 30 LEU B                                                    
residue 31 TRP B                                                    
residue 32 PRO B
residue 33 SER B
pdb 2L68chainB_2.pdb
residue 53 TYR B                                           
residue 54 ILE B                                     
residue 55 PRO B
residue 56 THR B
residue 57 GLY B
pdb 2L68chainB_3.pdb
residue 81 GLN B
residue 82 ARG B
residue 83 LEU B
residue 84 ASP B
residue 85 LEU B
residue 86 PRO B
pdb 2L68chainB_4.pdb
residue 105 SER B
residue 106 ARG B
residue 107 SER B                  
residue 108 THR B     
residue 109 PRO B                          
residue 110 HSE B
}
coordpdb chainA.pdb A
coordpdb chainB.pdb B
guesscoord
writepsf modeledEmrE.psf
writepdb modeledEmrE.pdb


#set mid [mol load psf modeledEmrE.psf pdb modeledEmrE.pdb]
