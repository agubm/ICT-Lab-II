function [ z, paprofdmSymbo] = modulate_ofdm( D,fft_size,cp_size,switch_graph )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

D_ifft=ifft(D);  %Inverse FFT
[k,n]=size(D_ifft);

a=fft_size+cp_size; %used to find position of second OFDM symbol for the graph
b=fft_size-cp_size; %position of bits to append

CP=zeros(cp_size,n);
for i=1:cp_size            %%%CP=last 256 bits of 1024 lenth frame.this cp is added infront of the frame.
    CP(i,:)=D_ifft(b+i,:);
end

A=[CP;D_ifft];  %Append CP

[m,n]=size(A);

z=reshape(A,[1 m*n]); %Parallel to serial conversion

outputer=z;
meanSquareValue = outputer*outputer'/length(outputer);
peakValue = max(outputer.*conj(outputer));
paprofdmSymbo = peakValue/meanSquareValue;

kk =1;
if kk ==1;
    zz=[];
    %OFDM in frequency domain computation:
    zz(1:fft_size) = abs(fft(z(1,:),fft_size));
    zz(1:fft_size) = abs(fft(z(1,:),fft_size));
    ofdm_freqdomain = zz(1:fft_size);
    f=(-fft_size/2:fft_size/2-1)/fft_size;
end


B=z(a+1:2*a);
if switch_graph==1
    figure;
    plot(real(B));
    title('OFDM symbol in time domain');
    xlabel('OFDM symbol sequence');
    ylabel('Amplitude');
    
    figure;
    plot(f,ofdm_freqdomain);
    xlim([-0.5 0.5])
    title('OFDM symbol in frequency domain');
    grid on
end

end

