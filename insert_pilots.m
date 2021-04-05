function [ D ] = insert_pilots( d, fft_size,N_blocks,pilot_symbol,switch_graph )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

D2=reshape(d,fft_size,N_blocks); 
D=[pilot_symbol,D2]; 

if switch_graph==1
    figure(3);
    plot(D,'r*');
    title('Pilot Insertion');
    grid on
    axis([-2 2 -2 2]);
end

end

