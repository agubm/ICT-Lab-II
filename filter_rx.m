function [ z_tilde ] =filter_rx( s_tilde,downsampling_factor,switch_graph,switch_off )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

filtlen = 4; % Filter length in symbols
rolloff = 0.25; % Filter rolloff factor
if switch_off ==0
    receive_filter=rcosdesign(rolloff,filtlen,downsampling_factor);
    rxFiltSignal = upfirdn(s_tilde,receive_filter,1,downsampling_factor); % Downsample and filter
    z_tilde = rxFiltSignal(filtlen + 1:end - filtlen); % Account for delay
    %Normalization     
    nom=modnorm(z_tilde,'avpow',1);
    z_tilde=z_tilde*nom;
    
    [H W] = freqz(z_tilde,1,512);
     if switch_graph==1
        figure;
        plot(W/pi,20*log10(abs(H)));
        xlabel('\omega/pi');
        ylabel('H in dB');
        title('Receiever filter output in normalize freq domain');
        hold on
        grid on
   
    
        figure
        hold off
        subplot(2,1,1)
        
        plot(real(z_tilde),'g');
        xlabel('Bits sequence');
        ylabel('Amplitude');
        title('receieve filter output in freq domain');
        ylabel('Real part of output of Rx filter')
        grid on
        subplot(2,1,2)
        plot(imag(z_tilde),'r');
        grid on
        xlabel('Bits sequence');
        ylabel('Amplitude');
        ylabel('Imaginary part of output of Rx filter')
    
   % eyediagram(z_tilde(1:192),downsampling_factor,'g');  
    %eyediagram(z_tilde(1:7000),20,'g');
     end

else
    z_tilde=s_tilde;

end

end


