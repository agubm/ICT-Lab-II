function [ D_tilde ] = demodulate_ofdm( z_tilde,fft_size,cp_size,switch_graph )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

L= length(z_tilde);
X=reshape(z_tilde,1,L);
m=fft_size+cp_size;
n=(L-mod(L,m))/m;%to make length of z_tilde dividable by 'fft_size+cp_size'
A= X(1:m*n);
A1=reshape(A,m,n); %serial to parallel
d_temp=A1(1+cp_size:m,:);
D_tilde=fft(d_temp);

if switch_graph==1;
    K=reshape(D_tilde,fft_size*n,1);
    scatterplot(K);
    title('Constellation diagram after OFDM demodulation')
end


end

