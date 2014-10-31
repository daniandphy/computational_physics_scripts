#!/home/jvermaas/Python/bin/python
import math,sys,re,os
import numpy as np
boltzmann= 0.001987191683
temperature=310.0
beta=1.0/(boltzmann*temperature)
penergies_l=[]
benergies_l=[]
win_l=[]


def printusage():
 #import sys
 #print ' one input file per line in list  \n'
 print 'USAGE: -pebwf \'list of unbiased potential energy files + list of bias energy files + list of windows  \' -wl \'win length (snapshots)\'  -o \'output format\'  '
 sys.exit()
def read_list_of_input(inputs_list):
    ## this function read the list of potential, bias, windows files
    global penergies_l,benergies_l,win_l

    inp_files_list=open(inputs_list, "r")
    for line in inp_files_list:
      COMMENT_LINE=re.match(r'^#',line)
      if not COMMENT_LINE:
	print("line:",line)
	  
	#temp_penergies_f,temp_benergies_f,temp_wins_f=line.split()
	temp_penergies_f,temp_wins_f=line.split()	
	penergies_l.append(read_data_file(temp_penergies_f))
	#benergies_l.append(read_data_file(temp_benergies_f))
	win_l.append(read_data_file(temp_wins_f))
	#print ("penergies_l length:",len(penergies_l))


###########
def read_data_file(input):
    ##this function receive the name of the file and then return  a list
    #data_file = open(input, "r")
    #for lines in data_file:
    with open(input, "r") as f:
	my_list=[line.split() for line in f]
	
    return np.array(my_list,dtype=float)
	

#####
def build_reduced_pot_wrapper():

    reduced_pot=penergies_l[0]
    #benergies_all=benergies_l[0]
    if len(penergies_l)>1:
	for i in range(1,len(penergies_l)):
	    reduced_pot=np.append(reduced_pot,penergies_l[i],axis=0)
            #np.append(benergies_all,penergies_l[i],0)

    #print ("size of benergies_all[np.newaxis,:] is:",np.shape(benergies_all[np.newaxis,:]))
    #reduced_pot=beta*(reduced_pot+benergies_all[np.newaxis,:])
    reduced_pot=beta*(reduced_pot)
    ####reshaping
    #reduced_pot.reshape((reduced_pot.shape[1],reduced_pot.shape[2]))
    #reduced_pot=reduced_pot[0] ####for some reasons ? no way 

    print ("new size of reduced pot is:",np.shape(reduced_pot))
    raw_min_reduced_pot=np.min(reduced_pot,axis=1)
    print("raw_min_reduced_pot.shape",raw_min_reduced_pot.shape,"(raw_min_reduced_pot[:,np.newaxis]).shape",(raw_min_reduced_pot[:,np.newaxis]).shape)
    
    min_subtracted_pot_arr=reduced_pot-raw_min_reduced_pot[:,np.newaxis]
   

    print("min_subtracted_pot_arr.shape",min_subtracted_pot_arr.shape)
    np.savetxt("test_min.out",min_subtracted_pot_arr,delimiter='\t')
    #print ("min_reduced_shape",np.min(reduced_pot,axis=0).shape,np.min(reduced_pot,axis=0) )
    
    return min_subtracted_pot_arr# -600.00
    

###########
def mbar(reduced_pot,win_arr):
    num_wins=len(win_arr)
    
    FE_old=np.zeros((1,num_wins))
    FE=FE_old[:]+10.00
    exp_minus_reduced_pot=np.exp(-reduced_pot)
    
    FE_err=1.0
    my_iter=0
    while np.any(abs(FE-FE_old)>0.0001):#*num_wins ):
	FE_old[0,:]=FE[0,:]
	#print("FE_old",FE_old)
	#print("reduced_pot[0,:]",reduced_pot[0,:])
	#print("FE_old-reduced_pot [0,:]",(FE_old-reduced_pot) [0,:])
        #print("FE_old-reduced_pot: shape ",(FE_old-reduced_pot).shape)
	denom=win_length*np.sum(np.exp(FE_old-reduced_pot),axis=1)
	#print("denom.shape",denom.shape)
	FE[0,:]=-np.log(np.sum(exp_minus_reduced_pot/denom[:,np.newaxis],axis=0))
	FE[0,:]-=FE[0,0]
        FE_err=np.sum(abs(FE-FE_old))
        
        if my_iter%100==0: 
		print (my_iter," FE_err: ",FE_err, "FE_last: ",FE[0,-1])
		print ("abs(FE-FE_old) ",abs(FE-FE_old))
	
        
        my_iter+=1
    
    print ("Final_itteration: ",my_iter," FE_err: ",FE_err,  "FE_last: ",FE[0,-1])
    return FE 



##########################################################################################################################################
if len(sys.argv)==1 or sys.argv[1].startswith('-h') or  sys.argv[1].startswith('--h'):
 printusage()
 exit()
for x in range (len(sys.argv)):
 if sys.argv[x] == '-pebwf':
      pebwf_list_file=sys.argv[x+1]
 if sys.argv[x] == '-wl':
      win_length=int(sys.argv[x+1])
 if sys.argv[x] == '-o':
      output_format=sys.argv[x+1]



read_list_of_input(pebwf_list_file)
win_arr=win_l[0]

reduced_pot=build_reduced_pot_wrapper()


print("reduced_pot.shape",reduced_pot.shape)
FE=mbar(reduced_pot,win_arr)
FE=(FE-np.min(FE))/beta

fe_diff_file=open('cum_fe_diff_'+output_format+'.out',"w")
for i in range(len(win_arr)):
  fe_diff_file.write(str(win_arr[i][0])+'\t'+str(FE[0,i])+'\n')
fe_diff_file.close()