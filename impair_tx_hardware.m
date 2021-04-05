function [ x, paprSymbo ] = impair_tx_hardware( s,clipping_threshold_tx,switch_graph )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

mag =abs(s);
phase = angle(s);
for i=1:length(mag)
    if mag(i)>=clipping_threshold_tx
        mag(i)=clipping_threshold_tx;
    else
        mag(i)=mag(i);
    end
end
%mag=mag/clipping_threshold_tx;

[a,b]=pol2cart(phase,mag);
x=complex(a,b);

% computing the peak to average power ratio for each symbol
outputer=transpose (x);
meanSquareValue = outputer*outputer'/length(outputer);
peakValue = max(outputer.*conj(outputer));
paprSymbo = peakValue/meanSquareValue; 


if switch_graph==1;
    figure(6);
    subplot(2,1,1)
    plot(real(s),'g');
    title('Non clipped signal')
    xlabel('Non clipped OFDM symbol sequence');
    ylabel('Amplitude');
    grid on
    ylim([-3 3])
    subplot(2,1,2)
    plot(real(x),'r');
    grid on
    ylim([-3 3])
    title('output of tx hardware')
    xlabel('Clipped OFDM symbol sequence');
    ylabel('Amplitude');
end


end

