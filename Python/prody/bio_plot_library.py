from prody import *
import numpy as np
import matplotlib.pyplot as plt

#PDB="../TM3_TM8_CA_apo_mut.pdb"
#DCD="../TM3_TM8_CA_apo_mut.aligned.dcd"
def readTXTtoArray(input_file):
      content=[]
      with open(input_file,'r') as f:
	for line in f:
		if not line.startswith("#"):
		   temp=map(float,line.split())
		   content.append(temp)
      return np.array(content) 	
			

################################################################################plotSqFlucts

def plotSqFlucts(modesarg,out_put='SqFlucts.pdf',resid_vec=None,xtick_step=1,legends=[],xlabel='resid',ylabel= 'Square fluctuations',**kwargs):
	"""Show scaled square fluctuations using :func:`~matplotlib.pyplot.plot`.
	Modes or mode sets given as additional arguments will be scaled to have
	the same mean squared fluctuations as *modes*."""
	import matplotlib.pyplot as plt
        
	show=[]
	plt.xlabel(xlabel)
	plt.ylabel(ylabel)
	i=0
	for modes in modesarg:
		sqf = calcSqFlucts(modes)
		if len(legends)>0:show.append(plt.plot( sqf,
		label=legends[i],**kwargs))
		else:show.append(plt.plot( sqf,label=str(modes),**kwargs))
		
		
		print(str(modes))
		i+=1
	
	if resid_vec!=None: xticks_labels=resid_vec[::xtick_step]
	else: xticks_labels=range(0,len(sqf),xtick_step)
	xticks_number=range(0,len(sqf),xtick_step)
	plt.xticks(xticks_number,xticks_labels,rotation=90)
        plt.legend()	
	plt.savefig(out_put)
	plt.close()

############################################################################## showOverlapTable
def showOverlapTable(modes_x, modes_y,out_put='OverlapTable.pdf',xlabel='',ylabel= '', **kwargs):
    """Show overlap table using :func:`~matplotlib.pyplot.pcolor`.  *modes_x*
    and *modes_y* are sets of normal modes, and correspond to x and y axes of
    the plot.  Note that mode indices are incremented by 1.  List of modes
    is assumed to contain a set of contiguous modes from the same model.

    Default arguments for :func:`~matplotlib.pyplot.pcolor`:

      * ``cmap=plt.cm.jet``
      * ``norm=plt.normalize(0, 1)``"""
    
    import matplotlib.pyplot as plt
    
    overlap = abs(calcOverlap(modes_y, modes_x))
    if overlap.ndim == 0:
        overlap = np.array([[overlap]])
    elif overlap.ndim == 1:
        overlap = overlap.reshape((modes_y.numModes(), modes_x.numModes()))

    #cmap = kwargs.pop('cmap', plt.cm.jet)
    #norm = kwargs.pop('norm', plt.Normalize(0, 1))
    show = (plt.pcolor(overlap, cmap=plt.cm.jet, norm=plt.Normalize(0, 1), **kwargs),
            plt.colorbar())
    #show = (plt.pcolor(overlap, cmap=plt.cm.jet, norm=None, **kwargs),
    #        plt.colorbar())

    x_range = np.arange(1, modes_x.numModes() + 1)
    plt.xticks(x_range-0.5, x_range,rotation=0)
    plt.xlabel(xlabel)
    y_range = np.arange(1, modes_y.numModes() + 1)
    plt.yticks(y_range-0.5, y_range)
    plt.ylabel(ylabel)
    plt.axis([0, modes_x.numModes(), 0, modes_y.numModes()])
    plt.savefig(out_put)
    plt.close()

################################################################
def showCrossCorr(modes,out_put='CrossCorr.pdf',resid_vec=None,ticks_step=1,title='',xlabel='resid',ylabel= 'resid',*args, **kwargs):
    """Show cross-correlations using :func:`~matplotlib.pyplot.imshow`.  By
    default, *origin=lower* and *interpolation=bilinear* keyword  arguments
    are passed to this function, but user can overwrite these parameters.
    See also :func:`.calcCrossCorr`."""

    import matplotlib.pyplot as plt
    arange = np.arange(modes.numAtoms())
    cross_correlations = np.zeros((arange[-1]+2, arange[-1]+2))
    cross_correlations[arange[0]+1:,
                       arange[0]+1:] = calcCrossCorr(modes)
    if not 'interpolation' in kwargs:
        kwargs['interpolation'] = 'bilinear'
    if not 'origin' in kwargs:
        kwargs['origin'] = 'lower'
    show = plt.imshow(cross_correlations, *args, **kwargs), plt.colorbar()
    plt.axis([arange[0]+0.5, arange[-1]+1.5, arange[0]+0.5, arange[-1]+1.5])
    plt.title(title)
    if resid_vec!=None: ticks_labels=resid_vec[::ticks_step]
    else: ticks_labels=range(0,len(cross_correlations),ticks_step)
    ticks_number=range(0,len(cross_correlations),ticks_step)
    plt.xticks(ticks_number,ticks_labels,rotation=90)
    plt.yticks(ticks_number,ticks_labels,rotation=0)
    plt.xlabel(xlabel)
    plt.ylabel(xlabel)
    plt.savefig(out_put)
    plt.close()

def plotXY(inputs,yerr=False,out_name='XY.pdf', title='',xlabel='',ylabel='',xticks_label=None,yticks_label=None,labels=None,legend_pos=0,*args, **kwargs):
    ''' time series should be list of array i.e. (XY1,XY2,...) '''
    
    plt.title(title)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    #plt.ylim(0,np.max(y))
    i=0
    
    for XY in inputs:
   	
        if yerr:
		plt.errorbar(XY[:,0],XY[:,1],XY[:,2],label=labels[i])
        else:
		plt.plot(XY[:,0],XY[:,1],label=labels[i])
		
        i+=1


    if labels!=None: plt.legend(loc=legend_pos)
    plt.savefig(out_name)
    plt.close()
    
######################################################################
if __name__=='__main__':
	pass
	#name="TM3-TM8"
	#pca=loadModel(name+'.pca.npz')

	#resid_vec=range(108,139)+range(403,434)
	#legends=['pca1','pca2','pc3']

	#plotSqFlucts((pca[:2],pca[1:2],pca[2:3]),out_put='first_three_pca.pdf',resid_vec=resid_vec,xtick_step=2,legends=legends)
