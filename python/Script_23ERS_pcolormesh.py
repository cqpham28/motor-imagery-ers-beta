# -*- coding: utf-8 -*-
"""
Created on Fri Mar 27 23:54:25 2020

@author: Admin
"""
def clear_all():
    from IPython import get_ipython
    get_ipython().magic('reset -sf')
clear_all()

def logic_test(X):
    import numpy as np
    Y=np.where(X==1)[0]
    if len(Y.tolist()) != 0:
        a=1
    else:
        a=0
    return a
    
days=[['10_08','10_09','10_10','10_12','10_13'],
    ['10_11','10_12','10_13','10_14','10_15'],
    ['10_13','10_17','10_18','10_19'],
    ['10_21','10_27','10_28','10_30','10_31'],
    ['11_01','11_02','11_03','11_05','11_13'],
    ['11_02','11_03','11_07','11_08'],
    ['10_29','11_06','11_09','11_12','11_16'],
    ['11_06','11_07','11_09','11_14','11_15'],
    ['11_11','11_13','11_17','11_19','11_20'],
    ['11_12','11_21','11_22'],
    ['11_14','11_15','11_20','11_26','11_27'],
    ['11_15','11_18','11_23'],
    ['11_19','11_22','11_23','11_24','11_25']]
name_folder=['[01]' , '[02]','[03]',
            '[04]','[05]','[06]',
            '[07]','[08]','[09]',
            '[10]','[11]','[12]','[13]']

task_name=['left hand','right hand','feet']
channel=['C3','Cz','C4']

from scipy.interpolate import interp2d
from scipy.io import loadmat
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
path='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Code\\Code_Harry\\'

filename1='ERS23_datasave'
filename2='ERStest'

ERS = loadmat(path + filename1 + '.mat')
test = loadmat(path + filename2 + '.mat')

ERS=ERS['ERS23_datasave']
test=test['ERStest']

listdata=[]
listtest=[]
#ERStest
for p in range(np.shape(test)[1]):
    listtest.append([])
    for d in range(np.shape(test[0][p])[1]):
        listtest[p].append([])
        for task in range(np.shape(test[0][p][0][d])[1]):
            listtest[p][d].append([])
            for trial in range(np.shape(test[0][p][0][d])[0]):
                if np.shape(test[0][p][0][d][trial][task][0])[0]!=0:
                    listtest[p][d][task].append([])
                    listtest[p][d][task][trial].append(test[0][p][0][d][trial][task])
                
#ERS23_datasave  ERS23_test  ERStest_23freq_value
for p in range(np.shape(ERS)[1]):
    listdata.append([])
    for d in range(np.shape(ERS[0][p])[1]):
        listdata[p].append([])
        for task in range(np.shape(ERS[0][p][0][d])[1]):
            listdata[p][d].append([])
            for trial in range(np.shape(ERS[0][p][0][d])[0]):
                if np.shape(ERS[0][p][0][d][trial][task][0])[0]!=0:
                    listdata[p][d][task].append([])
                    for ch in range(np.shape(ERS[0][p][0][d][trial][task])[1]):
                        listdata[p][d][task][trial].append(ERS[0][p][0][d][trial][task][0][ch])
                    
#Select data
for p in [11]:
    day=days[p-1]
    idname=name_list[p-1]
    ERS = [] 
    plt.close('all')
    for task in range(3):
        fig=plt.figure(figsize=[16,9])                    
        ERS=[np.zeros([12,23]),np.zeros([12,23]),np.zeros([12,23])]
        Ni=[0,0,0]
        Nd=[0,0,0]
        for d in range(len(listdata[p-1])):
            for trial in range(len(listdata[p-1][d][task])):
                maxf=[np.max(listdata[p-1][d][task][trial][0]),
                        np.max(listdata[p-1][d][task][trial][1]),
                        np.max(listdata[p-1][d][task][trial][2])]
                for ch in range(3):
                    if logic_test(listtest[p-1][d][task][trial][0].T[ch])==1:
                        ERS[ch] += listdata[p-1][d][task][trial][ch]/max(maxf)
                        Ni[ch] += 1
                    Nd[ch] += 1
        minERS=min([np.min(ERS[0]/Ni[0]),np.min(ERS[1]/Ni[1]),np.min(ERS[2]/Ni[2])])
        maxERS=max([np.max(ERS[0]/Ni[0]),np.max(ERS[1]/Ni[1]),np.max(ERS[2]/Ni[2])])
        for ch in range(3):
            ERS[ch] = ERS[ch]/Ni[ch]
            xi = np.arange(-3,10.01,0.01)
            yi = np.arange(13,35.01,0.01)
            X, Y = np.meshgrid(xi,yi)
            x=np.arange(-3,11)
            y=np.arange(13,36)
            ERScb=np.array(np.zeros([1,23]).tolist()+ERS[ch].tolist()+np.zeros([1,23]).tolist()).T
            f = interp2d(x,y, ERScb, kind='cubic')
            zi=f(xi, yi)
            ax=plt.subplot(1,3,ch+1)
            pcm=ax.pcolormesh(xi, yi, zi, cmap = plt.cm.jet, vmin=minERS, vmax=maxERS)
            ax.set_xticks(np.arange(-2.5,10.5))
            ax.set_xticklabels(['-3','','','0',' ',' ','3',' ',' ','6',' ',' ','9'],fontdict={'fontsize':15})
            ax.set_yticks(list(range(14,35,2)))
            ax.set_yticklabels([str(xt) for xt in range(14,35,2)],fontdict={'fontsize':17})
        
        
            if ch==1:
                ax.set_title('ID: '+ name_folder[p-1][1:3]+'           Task:  '+task_name[task]+'\n'+'\n'+
                         'Channel '+channel[ch],fontdict={'fontsize':18},
                         in_layout=True)
            else:
                ax.set_title('Channel '+channel[ch],fontdict={'fontsize':18})
            cbar=plt.colorbar(pcm)
            if ch==0:
                ax.set_ylabel('Frequency (Hz)',fontdict={'fontsize':18})
                cbar.set_label('Relative Power',fontsize=18)
                ax.set_xlabel('Time (second)',fontdict={'fontsize':18})
            cbar.ax.tick_params(labelsize=17)

        fig.set_tight_layout(True)
        mng=plt.get_current_fig_manager()
        mng.window.showMaximized()
        plt.show() 
        fig.savefig(path + 'pcolormesh-'+name_folder[p-1][1:3]+'-'+task_name[task]+'.png')       










                
                    
                    
                    
                    
                    
                    
