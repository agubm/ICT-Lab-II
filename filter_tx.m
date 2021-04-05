function [s]=filter_tx(z,oversampling_factor,switch_graph,switch_off)
if switch_off==0

filtlen = 4; % Filter length in symbols
rolloff = 0.25; % Filter rolloff factor 
tx_filter=rcosdesign(rolloff,filtlen,oversampling_factor); 
s_temp=upfirdn(z,tx_filter,oversampling_factor,1);

size(s_temp);
[m,n]=size(s_temp) ;
s_tem=reshape(s_temp,n,1);

%normalization
nom= modnorm(s_tem,'avpow',1);
s=s_tem*nom;    %s=s_tem./abs(s_tem); %mean(abs(s)^2 ==1)

[H W] = freqz(s,1,512);
     if switch_graph==1
        figure;
        plot(W/pi,20*log10(abs(H)));
        xlabel('\omega/pi');
        ylabel('H in DB');
        title('Transmit filter output in normalize frequency domain');
        
        figure;
        freqz(tx_filter)
        title('Designed Transmit filter');
         
        figure;
        hold off
        subplot(2,1,1)
        plot(real(s),'g');
        ylabel('real')
        grid on
        title('output of transmit filter');
        subplot(2,1,2)
        plot(imag(s),'r');
        grid on
        ylabel('imaginary')
    end
else
    s=z';
    
    [H W] = freqz(s,1,512);
     if switch_graph==1
        figure;
        plot(W/pi,20*log10(abs(H)));
        xlabel('\omega/pi');
        ylabel('H in DB');
        title('Transmit filter output in normalize frequency domain');
        
        figure;
        hold off
        subplot(2,1,1)
        plot(real(s),'g');
        ylabel('real')
        grid on
        title('output of transmit filter');
        subplot(2,1,2)
        plot(imag(s),'r');
        grid on
        ylabel('imaginary')
    end
end
