import sys
sys.path.append('/home/danial/script/python_script/prody')
from prody import *
import numpy as np
import matplotlib.pyplot as plt


############################################plot pca fluc
name="TM3-TM8"
	pca=loadModel(name+'.pca.npz')

	resid_vec=range(108,139)+range(403,434)
	legends=['pca1','pca2','pc3']

	plotSqFlucts((pca[:2],pca[1:2],pca[2:3]),out_put='first_three_pca.pdf',resid_vec=resid_vec,xstep=2,legends=legends)
###################################################
