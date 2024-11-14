function [f,P]=fourier_transform_n(y,Fs)

% n signal, n column

[m,n]=size(y);  %lay kich thuoc m x n cua ma tran so lieu

f=[0:m-1]*Fs/m;  %tao day gia tri tan so f(Hz)

% bien doi FFT cho tung cot so lieu
for k=1:n
    F(:,k)=fft(y(:,k),m);
    P(:,k)=(F(:,k).*conj(F(:,k)))/m;
end
