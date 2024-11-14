# -*- coding: utf-8 -*-
"""
Created on Thu Apr  9 01:00:45 2020

@author: Admin
"""

def clear_all():
    from IPython import get_ipython
    get_ipython().magic('reset -sf')
clear_all()
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

def logic_test(X):
    import numpy as np
    Y=np.where(X==1)[0]
    if len(Y.tolist()) != 0:
        a=1
    else:
        a=0
    return a

def moving_average(data,window):
    #movingmean_ver2(data,window,dim,option) dim=1, option=1
    #ndims(data)<=2 
    import numpy as np
    dim=0
    if window%2 == 0:
        window=window-1
        
    halfspace=int(np.ceil((window-1)/2))
    n=np.shape(data)

    start=np.append(np.ones([1,halfspace+1]),np.arange(2,(n[dim]-halfspace)+1))-1
    stop=np.append(np.arange(1+halfspace,n[dim]+1),np.ones([1,halfspace])*n[dim])-1
    divide=stop-start+1;
    CumulativeSum=np.cumsum(data)
    temp_sum=[]
    temp_sum1=[]
    for i in range(len(stop)):
        if int(start[i])==0:
            temp_sum.append(CumulativeSum[int(stop[i])]-CumulativeSum[int(start[i])])
            temp_sum1.append(temp_sum[i]+data[0])
        else:
            temp_sum.append(CumulativeSum[int(stop[i])]-CumulativeSum[int(start[i])-1])
            temp_sum1.append(temp_sum[i])
        
    result=temp_sum1/divide
    return result
                 
                 
        
import scipy.io
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
path2='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Code\\Code_Harry\\'
filename2='ERStest'

test = scipy.io.loadmat(path2 + filename2 + '.mat')
test=test['ERStest']

listtest=[]
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

beta_band=[]
beta_band.append([[20,23],[15,20],[13,15],[15,20],[19,23],[13,17],[20,23],
            [18,21],[13,16],[13,15],[13,16],[14,18],[18,23]])

beta_band.append([[26,32],[30,35],[32,35],[26,30],[27,30],[23,28],[32,35],
            [22,27],[18,24],[24,28],[24,28],[28,32],[21,26]])

fs=500
color=['royalblue','grey','crimson']
channel_name=['C3','Cz','C4']

for ib in range(2):     #len(beta_band)
    if ib==0:
        ibtext='lowbeta'
    elif ib==1:
        ibtext='highbeta'
    for p in [7]:     
        day=days[p]
        idname=name_folder[p]
        Pw=[np.zeros([6001,3]),np.zeros([6001,3]),np.zeros([6001,3])]
        Ni=np.zeros([3,3],dtype=int);
        Nd=np.zeros([3,1],dtype=int);
        for d in range(len(day)):     #len(days[p])
            path='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Data\\' + idname + '\\' + day[d] + '\\'
            data = scipy.io.loadmat(path + 'Pfurt-' + ibtext + '-' + idname[:4] + day[d] + '.mat')
            Power=data['Power'][0][0]
            data=[]
            for task in range(np.shape(Power)[1]):
                data.append([])
                for trial in range(np.shape(Power)[0]):
                    if np.shape(Power[trial][task])[0]!=1:
                        data[task].append([])
                        data[task][trial].append(Power[trial][task])
            
            for task in range(len(data)):
                for trial in range(len(data[task])):
                    maxP=max([np.max(data[task][trial][0].T[0]),
                              np.max(data[task][trial][0].T[1]),
                              np.max(data[task][trial][0].T[2])])
                    for ch in range(np.shape(data[task][trial][0])[1]):
                        if logic_test(listtest[p][d][task][trial][0].T[ch][3:])==1:
                            Pw[task][:,ch] += data[task][trial][0].T[ch]/maxP
                            Ni[task,ch] += 1
                            
                Pw[task] = Pw[task]/Ni[task]
                Nd[task,0] = trial+1
                
        tx=np.arange(6001)/fs
        power_smooth=[]
        ERS=[]
        for task in range(len(Pw)):
            power_smooth.append([])
            ERS.append([])
            for ch in range(np.shape(Pw[task])[1]):
                power_smooth[task].append(moving_average(Pw[task][:,ch],25))
                ref= np.mean(power_smooth[task][ch][2*fs-1:3*fs],axis=0)
                ERS[task].append((power_smooth[task][ch]-ref)/ref)
        fig,ax=plt.subplots(3,2)
        for task in range(len(ERS)):
            for ch in range(3):
                plot_ch,=ax[task,0].plot(tx,ERS[task][ch],linewidth=0.7,color=color[ch])
                plot_ch.set_label(channel_name[ch] + '        '+str(Ni[task,ch])+'/'+str(Nd[task,0]))
            v=ax[task,0].axis() 
            ax[task,0].plot([3,3],[v[2],v[3]],linestyle='-.',linewidth=0.6,color='k')
            ax[task,0].plot([9,9],[v[2],v[3]],linestyle='-.',linewidth=0.6,color='k')
            ax[task,0].plot([0,13.5],[0,0],linestyle='-.',linewidth=0.6,color='k')
            ax[task,0].legend(fontsize=7)
            ax[task,0].set_title('Name : ' + name_list[p] + '          Task : ' + task_name[task] + '          Freq = [' +
                                str(beta_band[ib][p][0]) + ' Hz , ' + str(beta_band[ib][p][1])+' Hz]',fontsize=7)
            ax[task,0].set_xticks(list(range(13))+[13.1])
            ax[task,0].set_xticklabels([str(xt) for xt in range(-3,10)]+['time (seconds)'],fontsize=7)
            
            #ax[task,0].tick_params(axis='both', which='major', labelsize=8)
            ax[task,0].yaxis.set_tick_params(labelsize=8)
            ax[task,0].set_ylabel('Relative Power',fontsize=7)
            ax[task,0].set_xlim([3,13.5])
        fig.set_tight_layout(True)
        mng=plt.get_current_fig_manager()
        mng.window.showMaximized()
        plt.show()
        
         

                
                    
            











