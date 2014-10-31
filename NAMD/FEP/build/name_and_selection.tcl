set name 4m48_wild_apo_Na2_popc
###list of binding ions::  na?: SOD 38 na1: SOD 701, na2: SOD 702, cl: CLA 703

set SEL "not ((resname SOD and resid 38 701) or (resname CLA and resid 703))"

###### FEP run
#set pocket "protein and resid 42 45 417 420 421 and noh"
set pocket "protein and resid 42 45 417 420 421  and name CA"
#set pocket "protein and (index 284 330 5555 5590 5602)"
set ion "resname SOD and resid 702"
#set centers "2.3 2.3 2.3 2.6 2.4"
#set force_constants "0.5"
set centers "4.36 4.37 4.23 4.63 3.76"
set force_constants "5.0"
