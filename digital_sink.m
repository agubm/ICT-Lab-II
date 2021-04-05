function [ BER] = digital_sink( b,b_hat,switch_graph )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

berr=abs(b-b_hat);
BER = sum(abs(b-b_hat));

%BER = bit_errors/length(b);
if switch_graph ==1
    figure;
    stem (berr, 'c');
    xlabel('Bit Sequence');
    ylabel('Amplitude');
    title('figure of binary estimate indicating erroneous positions')
end
end

