# -*- coding: utf-8 -*-
"""
Created on Tue Mar 31 15:59:49 2020

@author: Admin
"""

def clear_all():
    from IPython import get_ipython
    get_ipython().magic('reset -sf')
clear_all()

import scipy.io
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
path='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Code\\Code_Harry\\'

filename1='boxplot_01'

boxplot_01 = scipy.io.loadmat(path + filename1 + '.mat')

Pt=boxplot_01['Pt'][0][0][0][1][0][2]

Outer_Fence=boxplot_01['Outer_Fence'][0][0][0][1][0][2]

plt.close('all')

fig,ax=plt.subplots(2,2)


ax[0,0].boxplot(Pt, boxprops=dict(color='royalblue',linewidth=0.5),
               whiskerprops=dict(color='royalblue',linewidth=0.5),
               flierprops=dict(markeredgecolor='tomato', marker='.',markersize=1),
               medianprops=dict(color='grey'))

#ax[0,0].boxplot(Pt, boxprops={'color':'royalblue' , 'linewidth': 0.5},
#               whiskerprops={'color':'royalblue','linewidth': 0.5},
#               flierprops={'markeredgecolor':'tomato', 'marker':'.','markersize': 1},
#               medianprops={'color':'grey'})


ax[0,0].set_xticks(np.arange(1,24))
ax[0,0].set_xticklabels(np.arange(13,36),fontsize=8)
ax[0,0].set_yticks(np.arange(0,4001,500))
ax[0,0].set_yticklabels(np.arange(0,4001,500),fontsize=8)
fig.tight_layout()

med_ref=np.median(Pt,axis=0)

plot2,=ax[0,0].plot(np.arange(1,24),Outer_Fence.T,linestyle='-.',color='k',linewidth=1.2)
plot2.set_label('Upper Outer Fence')
plot1,=ax[0,0].plot(np.arange(1,24),med_ref,color='dimgrey',linestyle='dashed',linewidth=1.2)
plot1.set_label('Common Reference')

ax[0,0].legend()
ax[0,0].set_xlabel('Frequency (Hz)',fontsize=9)
ax[0,0].set_ylabel('[$\mu$V$^2$]',fontsize=9)
ax[0,0].set_ylim([0,3500])


ERS=[]
for i in range(np.shape(Pt)[0]):
    erstemp=[]
    for j in range(np.shape(Pt)[1]):
        erstemp.append((Pt[i,j]-med_ref[j])/med_ref[j])
    ERS.append(np.array(erstemp))
threshold=[]
for j in range(np.shape(Pt)[1]):
    threshold.append((Outer_Fence.T[j]-med_ref[j])/med_ref[j])
    
ax[1,0].boxplot(np.array(ERS), boxprops=dict(color='royalblue',linewidth=0.5),
               whiskerprops=dict(color='royalblue',linewidth=0.5),
               flierprops=dict(markeredgecolor='tomato', marker='.',markersize=1),
               medianprops=dict(color='grey'))

plot2,=ax[1,0].plot(np.arange(1,24),np.array(threshold),linestyle='-.',color='k',linewidth=1.2)
plot2.set_label('Activity Threshold')
plot1,=ax[1,0].plot([1,23],[0,0],linestyle='dashed',color='dimgrey',linewidth=1.2)
plot1.set_label('')

ax[1,0].legend()
ax[1,0].set_xticks(np.arange(1,24))
ax[1,0].set_xticklabels(np.arange(13,36),fontsize=8)
ax[1,0].set_yticks(np.arange(0,21,5))
ax[1,0].set_yticklabels(np.arange(0,21,5),fontsize=8)
ax[1,0].set_xlabel('Frequency (Hz)',fontsize=9)
ax[1,0].set_ylabel('Relative Power',fontsize=9)
ax[1,0].set_ylim([-3,15])

mng=plt.get_current_fig_manager()
mng.window.showMaximized()
plt.show() 





