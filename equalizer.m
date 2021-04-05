function [ d_bar ] = equalizer( d_tilde,pilot_symbol,switch_graph )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%tx_pilot = (2+2i)*ones(1024,1);
channel_estimate = d_tilde(:,1)./pilot_symbol;
Data=d_tilde(:,2:end);

[rows,columns]=size(Data);

for i=1:columns
    equalized_data(:,i)=Data(:,i)./channel_estimate;
end

d_bar=reshape(equalized_data,rows*columns,1);

 if switch_graph==1
    scatterplot(d_bar,1,0,'r.');
    title('Constellation diagram after Equalizer');
    xlabel('In-phase Amplitude');
    ylabel('Quadrature Amplitude');
    axis([-1.5 1.5 -1.5 1.5]);
    grid on
 end

end

