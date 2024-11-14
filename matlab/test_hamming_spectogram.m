clear
clc
close all

load handel
nfft = 512;  
noverlap = 128;
win = hamming(nfft);
subplot(2,1,1)
plot([1:length(y)]/Fs,y)

subplot(2,1,2)
spectrogram(y, win, noverlap, nfft, Fs, 'yaxis')
colormap('jet')
colorbar('off')
