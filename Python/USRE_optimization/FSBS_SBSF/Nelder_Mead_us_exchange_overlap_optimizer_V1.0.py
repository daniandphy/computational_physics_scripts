#!/usr/bin/env python
from numpy import *
import math,sys,pdb,time,re,os,copy


###const
conv_const=1.0
beta1=1.0/0.6
total_time=0.0
precision=0.001
knn_range=2
itr_counter=0
col=2
######end of defaults
def printusage():
 print 'USAGE: -il list of input -o output -col column number which contains dumped US values  -sc spring_constant/2 -cc converting const (e.g. deg->radian)'
 print ' -wmin position of min windows on reaction coordinate -wmax position of max windows on reaction coordinate  -nr number of replicas -pr convergence criteria (default=0.001)'
 sys.exit()
################################functions
def random_vector_producer(initial_vector,variation,quantity):
	iv_dimension=
	simplex
	for i in range(0,

###########################
def my_range(start,stop,step):
    x=[]
    
    while start <= stop+step/10:
        x.append(start)
        start+= step
        
    x=array(x)
    return x
################ mean
def mean(a):
 return math.fsum(a)/float(len(a))
##################variance
def var(x):
 return mean(x**2)-(mean(x))**2
#################### 
def effective_multiplier(x,y):
    ###for multilplying exp(x) * y
    if y!=0:

        log_y=log(abs(y))
        log_x_multiply_y=x+log_y
        return copysign(1,y)*exp(log_x_multiply_y)
    else:
        return 0.0

#################complementary error function
def err_fc(x):
    return math.erfc(x)
############  read data file
def read_data_file(input,col,conv_const):
    ##this function receive the name of the file and the coloumn of intnded data
    # and then return  an array it also make a global list which contains all 
    #data and all data_line are even in this array
    global all_data
    global min_number_of_line
    global input_num
    input_num+=1
   
    data_file = open(input, "r")
    data_arr=[]
    mean_var=zeros(2)
    for line in data_file:
     data_line=map(float,line.split())
     data_arr.append(data_line)
    
    data_arr=array(data_arr[:],dtype=float64)
    
    number_of_line=len(data_arr)
    #even we want data_arr a one-dimensional matrix but we still keep it as two dimensional [number of line,col-1:col] for appending part 
    data_arr=data_arr[:,col-1:col]*conv_const
    print("number_of_line",number_of_line)
    if  number_of_line < min_number_of_line or input_num==1 :
        min_number_of_line=number_of_line
    ###appending colomn to big matrix, important: both of them should have the same dimension
    ### that is why we kept data_arr as a two dimensional array
    if  input_num>1:
        all_data=append(all_data[0:min_number_of_line,:],data_arr[0:min_number_of_line,0:1],axis=1)
    else:
        all_data=data_arr[:,0:1]
    return data_arr
#################
def k_nearest_neighbor_finder(k,xm_dot):
    #return the index of the first kth nearest xdot to x in ascending order
    
    global pre_simulated_xdot_mean_var_array
    temp=abs(pre_simulated_xdot_mean_var_array[:,0]-xm_dot).argsort()
    
    nearest_neighbor_list=temp[0:k]
    
    return nearest_neighbor_list
###################
def k_nearest_neighbor_weights(k,xm_dot):
    
    #from http://www.statsoft.com/textbook/k-nearest-neighbors/
    global pre_simulated_xdot_mean_var_array
    nnw=zeros(k)
    knn=k_nearest_neighbor_finder(k,xm_dot)
    if pre_simulated_xdot_mean_var_array[knn[0],0] != xm_dot:
    	for i in range(0,k):
            ith_neighb_xdot=pre_simulated_xdot_mean_var_array[knn[i],0]
        
            D_m_ith_xdot=(abs(xm_dot-ith_neighb_xdot))**(1.2)
            nnw[i]=1.0/(D_m_ith_xdot)
    else:
        nnw[0]=1.0
        nnw[1:k]=0.0

            
    
    return nnw/sum(nnw)
    
    
###################
def mean_var_calc(xm_dot):
    global pre_simulated_xdot_mean_var_array
    global conv_const
    global knn_range# up to k_th nearest neighbors
    xm_dot_square_bar=0.0
    xm_dot_mean_var=zeros(3)
    
    weights=k_nearest_neighbor_weights(knn_range,xm_dot)
    nnl=k_nearest_neighbor_finder(knn_range,xm_dot)
    xm_dot_mean_var[0]=xm_dot
    for m in range (0,knn_range):
        i_index=nnl[m]
        xi_dot=pre_simulated_xdot_mean_var_array[i_index,0]
        xi_mean=pre_simulated_xdot_mean_var_array[i_index,1]
        xi_var=pre_simulated_xdot_mean_var_array[i_index,2]
        xm_dot_mean_var[1]+=weights[m]*(xi_mean-2*xi_var*beta1*s_const*(xi_dot-xm_dot))
        xm_dot_square_bar+=weights[m]*((xi_mean-2*xi_var*beta1*s_const*(xi_dot-xm_dot))**2+xi_var)
    xm_dot_mean_var[2]=xm_dot_square_bar-(xm_dot_mean_var[1])**2
        
    return xm_dot_mean_var

################################
def tot_acc_ratio(xm_dot,xn_dot):
    global beta1
    global s_const     #s_const is spring constant
    if xm_dot>xn_dot:
        temp =copy.copy(xm_dot)
        xm_dot=copy.copy(xn_dot)
        xn_dot=copy.copy(temp)
    
    xm_dot_mean_var=mean_var_calc(xm_dot)
    xn_dot_mean_var=mean_var_calc(xn_dot)
    delta_x_dot=xm_dot_mean_var[0]-xn_dot_mean_var[0]
    tot_var=xm_dot_mean_var[2]+xn_dot_mean_var[2]
    
    mean_diff=xm_dot_mean_var[1]-xn_dot_mean_var[1]
     
    if (err_fc((mean_diff-2*delta_x_dot*beta1*s_const*tot_var)/(sqrt(2.0*tot_var)))==0.0):
        return 0.5*err_fc(-(mean_diff)/(sqrt(2.0*(tot_var))))
    else:
        return 0.5*err_fc(-(mean_diff)/(sqrt(2.0*(tot_var))))+\
        0.5*exp((2*beta1*s_const*delta_x_dot)*(beta1*s_const*tot_var*delta_x_dot-mean_diff))*err_fc((mean_diff-2*delta_x_dot*beta1*s_const*tot_var)/(sqrt(2.0*tot_var)))
################################
def mean_exchange_acceptance(temp_xdots_array):
    global rep_num
    temp_all_ex_acc=zeros(rep_num-1)
    for i in range(0,rep_num-1):   
        temp_all_ex_acc[i]=tot_acc_ratio(temp_xdots_array[i],temp_xdots_array[i+1])
    return mean(temp_all_ex_acc)

################################# score_functions
def score_function(temp_xdots_reduced_array):
    score = 0.0
    global win_max
    global win_min
    global rep_num
    global beta1
    global s_const     #s_const is spring constant
    global test_mean
    temp_all_ex_acc=zeros(rep_num-1)
    temp_xdots_array=zeros(rep_num)
    temp_xdots_array[0]=win_min
    temp_xdots_array[rep_num-1]=win_max
    temp_xdots_array[1:rep_num-1]=temp_xdots_reduced_array
    
    for i in range(0,rep_num-1):   
        temp_all_ex_acc[i]=tot_acc_ratio(temp_xdots_array[i],temp_xdots_array[i+1])

        
    all_ex_acc_mean=math.fsum(temp_all_ex_acc)/float(rep_num-1.0)
    #print("========= all_ex_acc_mean= ",all_ex_acc_mean," var(exch_acc) ",var(temp_all_ex_acc),"===========")
    for i in range(0,rep_num-1):
      score +=-(temp_all_ex_acc[i]-all_ex_acc_mean)**2
    #print("score",score)
    return score
#########

###### diff_function
def gradient(x):
    #this function calculate the gradient of score_function at x
    global dx
    grad=zeros(len(x))
    x_plus_delta_x=copy.copy(x)
    for i in range(0,len(x)):
        x_plus_delta_x[i]=x_plus_delta_x[i]+dx
        grad[i]=(score_function(x_plus_delta_x)-score_function(x))/(dx)
        x_plus_delta_x[i]=x_plus_delta_x[i]-dx
    #print("grad",grad)
    return grad
#############

def BB_gradient_desc(x_old,mode):
    #Barzilai J. and Borwein J.M., (1988). Two point step size gradient method. IMA J. Numer. Anal., 8, 141-148.
     
    global precision
    global itr_counter
    
    if mode=="minimize":
        moving_direction=-1.0
    else:
        moving_direction=1.0
    bb_step_size=1.0/10000.0
    delta_x=bb_step_size*gradient(x_old)
    x_new=x_old+moving_direction*delta_x
    gradient_old=gradient(x_old)
    gradient_new=gradient(x_new)
    itr_counter=0
        
    while any(abs(gradient_new)>precision) or itr_counter <10 :
       
        itr_counter+=1
        delta_gradient=gradient_new-gradient_old
        #print "bb_step_size",bb_step_size
        #print("i=",i,"x_old[i]",x_old)
        #print("x_new[i]",x_new)
        #print("iteration=",itr_counter)
        #print "delta_x",delta_x
        #print "delta_gradient",delta_gradient
        #print("x_old[i]-x_new[i]",abs(x_old-x_new))
        bb_step_size=abs(sum(delta_x*delta_gradient)/sum(delta_gradient*delta_gradient))
        
        delta_x=bb_step_size*gradient_new
        x_old=copy.copy(x_new)
        x_new=x_old+moving_direction*delta_x
        gradient_old=copy.copy(gradient_new)
        gradient_new=gradient(x_new)
        
    return x_new
###################

#################################end of functions
if len(sys.argv)==1 or sys.argv[1].startswith('-h') or  sys.argv[1].startswith('--h'):
 printusage()
for x in range (len(sys.argv)):
 if sys.argv[x] == '-il':
      i_list=sys.argv[x+1]
 if sys.argv[x] == '-o':
      output=sys.argv[x+1]
 if sys.argv[x]=='-col':
      col=int(sys.argv[x+1])
 if sys.argv[x]=='-sc':
      s_const=float(sys.argv[x+1])
 if sys.argv[x]=='-cc':
     conv_const=float(sys.argv[x+1]) 
 if sys.argv[x]=='-nr':
     rep_num=int(sys.argv[x+1])
 if sys.argv[x]=='-wmin':
     win_min=float(sys.argv[x+1])
 if sys.argv[x]=='-wmax':
     win_max=float(sys.argv[x+1])
 if sys.argv[x]=='-pr':
    precision=float(sys.argv[x+1])
 
tic=time.clock()
outf=open(output,"w")

inp_list=open(i_list,'r')
bash_command="wc "+ i_list+"| awk '{print $1}'"
number_of_inp=os.popen(bash_command)
number_of_inp=int(number_of_inp.read())
pre_simulated_xdot_mean_var_array=zeros((number_of_inp,3))

all_data=[]
min_number_of_line=0
input_num=0
i=0


dx=1/10000.0

test_mean=0.51



for line in inp_list:

    inp_file,x_dot=line.split()
    pre_simulated_xdot_mean_var_array[i,0]=float(x_dot)*conv_const
    print 'input file:',inp_file
    inp_file=re.sub(r'\s+','',inp_file)#substitute the character like "\n" etc. with nothing (i.e., removing those)  
    temp_data_arr=read_data_file(inp_file,col,conv_const)
    pre_simulated_xdot_mean_var_array[i,1]=mean(temp_data_arr)
    pre_simulated_xdot_mean_var_array[i,2]=var(temp_data_arr)
    i+=1

####setting replicas(windows) with equal difference in the beginning 
#initial_xdots_array=zeros(rep_num)
win_min=win_min*conv_const
win_max=win_max*conv_const

initial_difference=(win_max-win_min)/(rep_num-1.0)
initial_xdots_array=my_range(win_min,win_max,initial_difference)
result=zeros(rep_num)
result[0]=win_min
result[rep_num-1]=win_max

result[1:rep_num-1]=BB_gradient_desc(initial_xdots_array[1:rep_num-1],"maximize")


outf.write ('displacement of replicas from equi difference positions on reaction coordinate are'+'\n')
for i in range(0,rep_num):

   outf.write (str((result[i]/conv_const)-(initial_xdots_array[i]/conv_const))+'\t')
outf.write('\n'+'##############'+'\n')
outf.write('\n'+'changing in exchange acceptance ratio '+'\n')
for i in range(0,rep_num-1):
    overlap_new=tot_acc_ratio(result[i],result[i+1])
    overlap_old=tot_acc_ratio(initial_xdots_array[i],initial_xdots_array[i])
    outf.write(str(overlap_new-overlap_old)+'\t')

outf.write('\n'+'##############'+'\n')              

outf.write ('best sets after'+ str(itr_counter)+' iterations are:'+'\n')

for i in range(0,rep_num):

   outf.write (str(result[i]/conv_const)+'\t')
   
outf.write('\n'+'##############'+'\n')


for i in range(0,rep_num-1):
    overlap=tot_acc_ratio(result[i],result[i+1])
    outf.write('overlap of window= '+str(result[i]/conv_const)+' and window= '+str(result[i+1]/conv_const)+ ' is ' + str(overlap) +'\n')

               
toc=time.clock()
total_time+=toc-tic

print('elapsed time= '+str(total_time)+' s')
