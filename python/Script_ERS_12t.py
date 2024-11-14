# -*- coding: utf-8 -*-
"""
Created on Thu Mar 19 18:08:04 2020

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
from scipy.signal import butter, lfilter


def butter_bandpass(lowcut, highcut, fs, order=7):
    nyq = 0.5 * fs
    low = lowcut / nyq
    high = highcut / nyq
    b, a = butter(order, [low, high], btype='bandpass')
    return b, a


def butter_bandpass_filter(data, lowcut, highcut, fs, order=7):
    b, a = butter_bandpass(lowcut, highcut, fs, order=order)
    y = lfilter(b, a, data)
    return y

def spectrum_analysis(S,fs):
    import numpy as np
    from scipy.fftpack import fft
    m=len(S)
    f= np.arange(m)*fs/m #dung shape, cho m ghi la m[0]
    F=fft(S)
    P=((abs(F))**2)/m
    return f,P
        
import scipy.io
import numpy as np
import matplotlib.pyplot as plt

plt.close('all')
path='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Code\\Code_Harry\\'
path2='D:\\Working\\My work\\EEG\\Cuong_Minh\\2020\\Data\\'

filename1='ERS_datasave'
filename2='ERStest'
filename3='ERS_Outer_Fence'
filename4='median_ref'
filename5='ERS23_datasave'

ERS = scipy.io.loadmat(path + filename1 + '.mat')
test = scipy.io.loadmat(path + filename2 + '.mat')
Outer_Fence = scipy.io.loadmat(path + filename3 + '.mat')
median_ref = scipy.io.loadmat(path + filename4 + '.mat')
ERS23=scipy.io.loadmat(path + filename5 + '.mat')

ERS=ERS['ERS_datasave']
test=test['ERStest']
Outer_Fence=Outer_Fence['ERS_Outer_Fence']
median_ref=median_ref['median_ref']
ERS23=ERS23['ERS23_datasave']

listdata=[]
listtest=[]
listOuterFence=[]
listMedianRef=[]
listERS23=[]

channel=['C3','Cz','C4']
col=['royalblue','forestgreen','dimgray']
#ERS_datasave  ERStest  ERStest_freq_value

for p in range(np.shape(ERS)[1]):
    listdata.append([])
    listtest.append([])
    for d in range(np.shape(ERS[0][p])[1]):
        listdata[p].append([])
        listtest[p].append([])
        for task in range(np.shape(ERS[0][p][0][d])[1]):
            listdata[p][d].append([])
            listtest[p][d].append([])
            for trial in range(np.shape(ERS[0][p][0][d])[0]):
                if np.shape(test[0][p][0][d][trial][task][0])[0]!=0:
                    listdata[p][d][task].append([])
                    listtest[p][d][task].append([])
                    listdata[p][d][task][trial].append(ERS[0][p][0][d][trial][task])
                    listtest[p][d][task][trial].append(test[0][p][0][d][trial][task])

#Outer_Fence
for p in range(np.shape(Outer_Fence)[1]):
    listOuterFence.append([])
    listMedianRef.append([])
    for d in range(np.shape(Outer_Fence[0][p])[1]):
        listOuterFence[p].append(Outer_Fence[0][p][0][d])
        listMedianRef[p].append(median_ref[0][p][0][d])

#ERS23_datasave  ERS23_test  ERStest_23freq_value

for p in range(np.shape(ERS23)[1]):
    listERS23.append([])
    for d in range(np.shape(ERS23[0][p])[1]):
        listERS23[p].append([])
        for task in range(np.shape(ERS23[0][p][0][d])[1]):
            listERS23[p][d].append([])
            for trial in range(np.shape(ERS23[0][p][0][d])[0]):
                if np.shape(ERS[0][p][0][d][trial][task][0])[0]!=0:
                    listERS23[p][d][task].append([])
                    for ch in range(np.shape(ERS23[0][p][0][d][trial][task])[1]):
                        listERS23[p][d][task][trial].append(ERS23[0][p][0][d][trial][task][0][ch])
                
          
#Select data
p=1 ; d=2 ; trial=23 ; task=1

EEG = scipy.io.loadmat(path2 + name_folder[p-1] + '\\' + days[p-1][d-1] + '\\'
                       + name_folder[p-1][:4] + days[p-1][d-1] + '.mat')

fs=EEG['fs']
fs=fs[0]
EEG=EEG['class_eeg']
EEG=EEG[trial-1][task-1]

plotdata=listdata[p-1][d-1][task-1][trial-1]
plotdata=plotdata[0]
test=listtest[p-1][d-1][task-1][trial-1]
test=test[0]

axis=[]

fig1,ax=plt.subplots(3,1,figsize=(12,8))
t=np.arange(6001)/fs
t=t.T
for i in range(3):
    
    ax[i].plot(np.arange(-3,9)+0.5,plotdata[:,i],color='gray', linestyle='dashed',linewidth=2)
    for j in range(np.shape(test)[0]):
        if test[j,i] == 1:
            mar='*'
            mec='crimson'
            mfc='crimson'
        else:
            mar='.'
            mec='royalblue'
            mfc='royalblue'
            
        ax[i].plot(j-2.5,plotdata[j,i],marker=mar,markeredgecolor=mec,markerfacecolor=mfc,markersize=16)
    
    axis.append(ax[i].axis()[2:])
    ax[i].set_xticks(np.arange(-3,10))
    ax[i].set_xlabel('Time (second)',fontdict={'fontsize':16})
    ax[i].set_ylabel('Relative Power',fontsize=16)
    ax[i].set_xticklabels([str(xt) for xt in range(-3,10)],fontsize=15)
    ax[i].yaxis.set_tick_params(labelsize=15)
    
axis=np.array(axis)
for i in range(np.shape(test)[1]):
    ax[i].plot([0,0],[np.min(axis),np.max(axis)],color='silver',linestyle='-.',linewidth=2)
    ax[i].plot([6,6],[np.min(axis),np.max(axis)],color='silver',linestyle='-.',linewidth=2)
    ax[i].set_ylim([np.min(axis),np.max(axis)])
    ax[i].text(7.5,11,'Channel ' + channel[i],fontsize=16)
    if i==0:
        ax[i].set_title('ID: '+ name_folder[p-1][1:3] + '                  Task: '
                      + task_name[task-1] + '                  Trial: '+str(trial),fontsize=16)
fig1.set_tight_layout(True)
mng=plt.get_current_fig_manager()
mng.window.showMaximized()
plt.show()
fig1.savefig(path + 'pic1')    


Outer_Fence=listOuterFence[p-1][d-1].T[2]
median_ref=listMedianRef[p-1][d-1].T[2]
ERS23=listERS23[p-1][d-1][task-1][trial-1][2]

#Phan tich pho 12 thoi diem
S=butter_bandpass_filter(EEG[:,2],13,35, fs[0], order=7)
fig2=plt.figure(2)
for i in range(12):
    f,P=spectrum_analysis(S[i*fs[0]:(i+1)*fs[0]],fs[0])
    ax=plt.subplot(5,3,i+1)
    ax.plot(f,P,linewidth=0.6,color='k')
    ax.plot(np.arange(13,36),median_ref,linestyle='dashed',color='grey')
    ax.set_xlim([13,35])
    ax.set_xlabel('Frequency (Hz)',fontsize=9)
    ax.set_ylabel('[$\mu$V$^2$]',fontsize=9)
    ax.yaxis.set_tick_params(labelsize=8)
    ax.set_xticks(list(range(15,40,5)))
    ax.set_xticklabels([str(xt) for xt in range(15,40,5)],fontsize=8)
'''ax=plt.subplot(5,3,i+2)
ax.plot(t[9*fs[0]:10*fs[0]],S[9*fs[0]:10*fs[0]],linewidth=0.6,color='k')
ax.set_xlabel('Time (second)',fontsize=9)
ax.set_ylabel('[$\mu$V]',fontsize=9)
ax.set_xlim([9,10])
ax.set_ylim([-40,40])
ax.yaxis.set_tick_params(labelsize=8)
ax.set_xticks(np.arange(9,10.25,0.25))
ax.set_xticklabels(np.arange(6,7.25,0.25),fontsize=8)

ax=plt.subplot(5,3,i+3)
ax.plot(t[1*fs[0]:2*fs[0]],S[1*fs[0]:2*fs[0]],linewidth=0.6,color='k')
ax.set_xlabel('Time (second)',fontsize=9)
ax.set_ylabel('[$\mu$V]',fontsize=9)
ax.set_xlim([1,2])
ax.set_ylim([-40,40])
ax.yaxis.set_tick_params(labelsize=8)
ax.set_xticks(np.arange(1,2.25,0.25))
ax.set_xticklabels(np.arange(-2,-0.75,0.25),fontsize=8)'''
fig2.set_tight_layout(True)
mng=plt.get_current_fig_manager()
mng.window.showMaximized()
plt.show()

fig3=plt.figure(3)
for i in range(12):
    ax=plt.subplot(5,3,i+1)
    ax.plot(np.arange(13,36),ERS23[i],linewidth=1,color='k')
    ax.plot(np.arange(13,36),Outer_Fence,linewidth=1,linestyle='-.',color='k')
    ax.set_xlim([13,35])
    ax.set_xlabel('Frequency (Hz)',fontsize=9)
    ax.set_ylabel('Relative Power',fontsize=7)
    
    ax.set_xticks(list(range(15,40,5)))
    ax.set_xticklabels([str(xt) for xt in range(15,40,5)],fontsize=8)
    ax.yaxis.set_tick_params(labelsize=8)
    max_diff=np.max(ERS23[i]-Outer_Fence)
    xmax=np.where((ERS23[i]-Outer_Fence)==max_diff)[0]
    if max_diff > 0:
        ax.plot(xmax+13,ERS23[i][xmax],marker='+',color='crimson')

fig3.set_tight_layout(True)
mng=plt.get_current_fig_manager()
mng.window.showMaximized()
plt.show()









