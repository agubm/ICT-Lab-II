function [ s_tilde ] = impair_rx_hardware( y,clipping_threshold_rx,switch_graph )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

R=abs(y);
theta=angle(y);
if R>clipping_threshold_rx;
    R=1;
    r=R;
else 
    r=R;
end
[a,b]=pol2cart(theta,r);
s_tilde=a+b*1i;


if switch_graph==1;
    figure;
    subplot(2,1,1)
    plot(real(y),'g');
    title('recieved signal')
    grid on
    ylim([-3 3])
    subplot(2,1,2)
    plot(real(s_tilde),'r');
    grid on
    title('output of rx hardware')
    ylim([-3 3])

end

