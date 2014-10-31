#!/home/jvermaas/Python/bin/python
import math,sys,re,os
import numpy as np
kcal_kt_ene=0.593*310.00/300.00
beta=1.0/kcal_kt_ene
def printusage():
 #import sys
 #print ' one input file per line in list  \n'
 print 'USAGE: -fepcolvcf \'fep colvar file name list file\' -o \'output format\' -cenkf \'center-k file\'  '
 sys.exit()
def read_list_of_input(inputs_list):
    ## this fundction read the list of fepout and colvar files
    inp_files_list=open(inputs_list, "r")
    for line in inp_files_list:
      COMMENT_LINE=re.match(r'^#',line)
      if not COMMENT_LINE:  
	fepout_file,colvar_file=line.split()
	current_input_lambda_index_list,start_equi_step, start_coll_step,final_coll_step=read_fepout_data_file(fepout_file)
        print "final_coll_step: ", final_coll_step
        print "current_input_lambda_index_list:",current_input_lambda_index_list
        #print "len(bias_ene_list[0][:]):", len(bias_ene_list[0][:])
	read_colvar_data_file(current_input_lambda_index_list,start_equi_step, start_coll_step,final_coll_step,colvar_file)


###########
def read_fepout_data_file(input):
    ##this function receive the name of the file and then return  a list
    data_file = open(input, "r")
    global fepout_data_list
    global lambda_list
    global bias_ene_list
    start_equi_step=0
    start_coll_step=0
    final_coll_step=0
    current_input_lambda_index_list=[] ##this will be used to find the value of lambda in related colvar traj
    for line in data_file:
     COMMENT_LINE=re.match(r'^#',line)
     if COMMENT_LINE:
       NEW_FEP_WIN_ON=re.match(r'^#NEW FEP',line)
       COLLECTION_ON= re.match(r'^#STARTING',line)
       if NEW_FEP_WIN_ON:
       
        temp_lambda=float(line.split()[6])
        if not temp_lambda in lambda_list:
          lambda_list.append(temp_lambda)
          fepout_data_list.append([])
          bias_ene_list.append([])

	lambda_ind=lambda_list.index(temp_lambda)
        current_input_lambda_index_list.append(lambda_ind) 
	

      

     else:
       temp=line.split()
       if NEW_FEP_WIN_ON and not start_equi_step: ##this if will be true only once
         start_equi_step=int(temp[1])
         #print "start_equi_step: ", start_equi_step

       if COLLECTION_ON and not start_coll_step:  ##this if will be true only once         
         start_coll_step=int(temp[1])
	 print float(line.split()[6])
         #fepout_data_list[lambda_ind].append(delta_E)
         print "start_coll_step: ", start_coll_step
       if COLLECTION_ON :
         final_coll_step=int(temp[1])
         delta_E=float(temp[6])
	 fepout_data_list[lambda_ind].append(delta_E)
         
    return current_input_lambda_index_list,start_equi_step, start_coll_step,final_coll_step

########END read_fepout_data_file
def read_colvar_data_file(current_input_lambda_index_list,start_equi_step, start_coll_step,final_coll_step,input):
    ##this function receive the name of the file and then return  a list
    data_file = open(input, "r")
    global bias_ene_list,lambda_list,fepout_data_list
    global center_vec,k_vec
    step_list=[]
    add_last_step=0
    for line in data_file:
     comment_line=re.match(r'^#',line)
     if not comment_line:
      temp=line.split()
      step=int(temp[0])
      #step_line=map(int,line.split())
      #print step_line
      current_ind=int(step/(final_coll_step+1))
      interval_ll=current_ind*final_coll_step + start_coll_step
      interval_ul=(current_ind+1)*final_coll_step
      
      if interval_ul> (len(current_input_lambda_index_list)* final_coll_step):
         print current_ind,interval_ll, interval_ul,(len(current_input_lambda_index_list)* final_coll_step)
         return
      current_position_in_lambda_list=current_input_lambda_index_list[current_ind]
      
      if step>=interval_ll and step<interval_ul:
        data_line=map(float,temp[1:]) 
        step_list.append(step)
        colvar_array=np.array(data_line)
        temp_ene=bias_energy_calc(colvar_array,center_vec,k_vec)
        bias_ene_list[current_position_in_lambda_list].append(temp_ene)
        #if step<252000 and step>251500:
           #print "step==",step,temp
           #print center_vec,k_vec
           #print "step==755090",temp_ene
           #print "current_position_in_lambda_list ",current_position_in_lambda_list
           #print "length(bias_ene_list[current_position_in_lambda_list])"
           #print len(bias_ene_list[current_position_in_lambda_list])
           #print "fepout_data_list" ,fepout_data_list[current_position_in_lambda_list][len(bias_ene_list[current_position_in_lambda_list])-1]
           #print "############################"


      elif step == interval_ul :
          add_last_step=(add_last_step+1)%2 ##this is because the last step repeated twice  
          if add_last_step:
            step_list.append(step)
            colvar_array=np.array(data_line)
            temp_ene=bias_energy_calc(colvar_array,center_vec,k_vec)
            bias_ene_list[current_position_in_lambda_list].append(temp_ene)
      #if current_ind==0 and (step <=interval_ll +50  or step >=interval_ul -50 ) :
         #print "step, interval_ll, interval_ul,bias_ene_list", step, interval_ll,  interval_ul,len(bias_ene_list[current_ind])
        #if step==interval_ll or step==(interval_ul-10):
           #print "step:",step
      #else:
	#print "current_ind: ",current_ind, "step:",step
        #print "lambda_list[current_position_in_lambda_list]"
        
    #return step_list, np.array(data_list)
    print "temp[0:]",temp[0:]
    print "final_step:",step


def read_center_data_file(input):
    ##this function receive the name of the file and then return  a list
    data_file = open(input, "r")
    center_list=[]
    k_list=[]
    for line in data_file:
     
     center_line,k_line=map(float,line.split())
     center_list.append(center_line)
     k_list.append(k_line)
    #print center_list,k_list
    return np.array(center_list), np.array(k_list)
#####

def read_weights(input):
    ##this function receive the name of the file and then return  a list
    data_file = open(input, "r")
    weights=[]
    for line in data_file:
     
     weight=float(line.split()[2])
     
     weights.append(weight)
    #print center_list,k_list
    return np.array(weights)
#####

def bias_energy_calc(data_vec,center_vec,k_vec):
    
    ene=np.sum(0.5*k_vec*(data_vec-center_vec)**2)
      
    return ene

####################
if len(sys.argv)==1 or sys.argv[1].startswith('-h') or  sys.argv[1].startswith('--h'):
 printusage()
for x in range (len(sys.argv)):
 if sys.argv[x] == '-fepcolvcf':
      fepcolv_list_file=sys.argv[x+1]
 if sys.argv[x] == '-cenkf':
      center_k_file=sys.argv[x+1]
 if sys.argv[x] == '-o':
      output_format=sys.argv[x+1]
# if sys.argv[x] == '-in':
      output_format=sys.argv[x+1]
# if sys.argv[x] == '-o':
      output_format=sys.argv[x+1]

fepout_data_list=[]
lambda_list=[]
#colvar_data_list=[]
bias_ene_list=[]
center_vec,k_vec=read_center_data_file(center_k_file)
read_list_of_input(fepcolv_list_file)
#step_data,colvar_data=read_colvar_data_file(colvar_file)


#delta_E_data=read_fepout_data_file(fepout_file)

#bias_energy_list=bias_energy_calc(colvar_data,center_data,k_data)



#print "len(fepout_data_list): ", len(fepout_data_list)
#print "len(fepout_data_list[0][:]): ", len(fepout_data_list[0][:])
#print "len(bias_ene_list[0][:]): ", len(bias_ene_list[0][:])
#print "len(bias_ene_list[1][:]): ", len(bias_ene_list[1][:])
copy_command= 'cp ~/script/generalized_wham/gwham.0.4/gwham reweigther'
#print copy_command
os.system(copy_command)
fe_diff=np.zeros(len(fepout_data_list),dtype=np.float64)
i=0
for win in bias_ene_list:
 #bias_output_file=output_format+'_bias_'+str(i)+'.out'
 #bias_out=open (bias_output_file,"w")
 #j=0
 #for line in win:
  #bias_out.write('0 '+str(j)+' '+str(line)+'\n')
  #j=j+1
 #bias_out.close()
 #number_of_data_points=len(win)
 #weight_out_file=output_format+'_weight_'+str(i)+'.out'
 #err_out_file=output_format+'_weight_'+str(i)+'.err'
#######
 unnorm_weights=np.exp(beta*np.array(win))
 norm_weights=unnorm_weights/np.sum(unnorm_weights)
#######
 #run_command="./reweigther -w 1 -l "+ str(number_of_data_points)+' -t 310 < '+bias_output_file+ ' > '+weight_out_file+' 2> ' +err_out_file
 #os.system(run_command)
 #unnorm_weights=read_weights(weight_out_file)
 
 exp_minus_beta_deltaE=np.exp(-beta*np.array(fepout_data_list[i]))
 #unnorm_exp_minus_beta_deltaE=np.average(exp_minus_beta_deltaE,weights=unnorm_weights)
 unnorm_exp_minus_beta_deltaE=np.sum(exp_minus_beta_deltaE*unnorm_weights)
 fe_diff[i]=(-1.00/beta)*np.log(unnorm_exp_minus_beta_deltaE/np.sum(unnorm_weights))

 
 #print run_command
 
 i+=1
print fe_diff
cum_fe_diff=np.cumsum(fe_diff)

i=0
cum_fe_diff_file=open('cum_fe_diff_'+output_format+'.out',"w")
for my_lambda in lambda_list:
  cum_fe_diff_file.write(str(my_lambda)+'\t'+str(fe_diff[i])+'\t'+str(cum_fe_diff[i])+'\n')
  i+=1
cum_fe_diff_file.close()

#print sum(norm_weights),len(norm_weights),j
