clear all;clc;
%% define parameters

switch_graph = 0;                 % 1/0--> show/not show the graph
switch_off = 0;                   % 1/0--> switch off/on the block

fft_size = 1024;                     % FFT length /OFDM symbol length
parity_check_matrix = [1 1 0 1 1 0 0; 1 0 1 1 0 1 0; 0 1 1 1 0 0 1];          % code parity check matrix
constellation_order =4;         % 2--> 4QAM; 4-->16QAM; 6-->64QAM
frame_size = 16384;                   % frame length 16384 for 4QAM & 16QAM, 49152 for 4,16 & 64 QAM
n_zero_padded_bits =[];            % no. of zeros added after encoding
pilot= [ -0.7071 - 0.7071i;  -0.7071 + 0.7071i; 0.7071 - 0.7071i;  0.7071+ 0.7071i ];% generated QPSK sequence pilot symbols to be randomized
randm=randi([1 4],1024,1);
ran=[];
for ii= 1:length(randm)
    ran(ii)= pilot(randm(ii));
end
pilot_symbol=ran'; %Randomized QPSK sequence
cp_size = ceil(fft_size/6);       % CP length
oversampling_factor =20;           % oversampling factor
downsampling_factor = oversampling_factor;          % downsampling factor
clipping_threshold_tx = 10;        % tx clipping_threshold =1 for hard clipping, =1.9 for weak clipping, =10 for no clipping
N_blocks =((frame_size*7)/(4*constellation_order))/fft_size;                    % no. of blocks
clipping_threshold_rx = clipping_threshold_tx;        % rx clipping_threshold
channel_type = 'AWGN';                 % channel type: 'AWGN', 'FSBF'
snr_db =[30];                        % SNRs in dB
iter = 10;                         % no. of iteration

%% initialize vectors
% You can save the BER result in a vector corresponding to different SNRs

BER_uncoded =[];
BER_coded = [];
SNR_coded = [];
SNR_uncoded = [];

%% OFDM transmission


j=1;
while(j<=2)
    for ii = 1 : length(snr_db) % SNR Loop
            Ber=[];
            switch_graph = 0;
            paprSymbol=[];
        for jj = 1 : iter      % Frame Loop, generate enough simulated bits
            %Digital Source
            b=generate_frame(frame_size,switch_graph);
            %Channel Coding
            if j==2
                switch_off=1;
                N_blocks =frame_size/(1024*constellation_order); 
            else
                switch_off=0;
            end
            
            div=1024;
            if switch_off==1
                
                if (mod(length(b),div)>0) 
                    n_zero_padded_bits = div-mod(length(b),div);
                else
                    n_zero_padded_bits=0;
                end
                
            else
                zero_add=(length(b))*7;
                if (mod(zero_add,div)>0)
                    n_zero_padded_bits = div-mod(zero_add,div);
                else
                    n_zero_padded_bits=0;
                end
                
            end
            
            c=encode_hamming(b,parity_check_matrix,n_zero_padded_bits,switch_off);
            
            
            %Modulation
            d=map2symbols(c,constellation_order,switch_graph);
            
            
            %Pilot Insertion
            D=insert_pilots(d,fft_size,N_blocks,pilot_symbol,switch_graph);
          
            %OFDM
            [z,paprofdmSymbo]=modulate_ofdm(D,fft_size,cp_size,switch_graph);
            
            %TX Filter
            s=filter_tx(z,oversampling_factor,switch_graph,switch_off);
            
            
            %TX Hardware
            [x, paprSymbo ]=impair_tx_hardware(s,clipping_threshold_tx,switch_graph);
            paprSymbol(jj)=paprSymbo;
            if switch_graph==1;
                figure;
                paprSymboldB = 10*log10(paprSymbol);
                [n xx] = hist(paprSymboldB,[0:1:iter]);
                plot(xx,cumsum(n)/iter,'LineWidth',2);
                xlabel('papr, x dB');
                ylabel('Probability, X');
                title('CDF plots of PAPR of OFDM ');
                grid on 
            end
            
            %Channel
            y=simulate_channel(x,snr_db(ii),channel_type);
            
            
            %RX Hardware
            s_tilde = impair_rx_hardware(y,clipping_threshold_rx,switch_graph);
            
            %RX Filter
            z_tilde = filter_rx(s_tilde,downsampling_factor,switch_graph,switch_off);
            
            %OFDM Demod
            
            D_tilde=demodulate_ofdm(z_tilde,fft_size,cp_size,switch_graph);
            
            %Equalizer
            d_bar=equalizer(D_tilde,pilot_symbol,switch_graph);
            
            %Demodulation
            c_hat=detect_symbols(d_bar,constellation_order,switch_graph);
            
            
            %Channel Decoding
            if j==2
                switch_off=1;
            else
                switch_off=0;
            end
            b_hat=decode_hamming(c_hat,parity_check_matrix,n_zero_padded_bits,switch_off);
            
            
            %Digital Sink
            [BER]= digital_sink(b,b_hat,switch_graph);
            
            Berr(jj)=BER;
            if jj == iter-1
                switch_graph = 1;
            end
            if jj == iter
                Ber=sum(Berr)/(length(b)*iter);
            end
        end
        if j==1
            BER_coded(ii,1)=Ber;
            SNR_coded(ii,1)=snr_db(ii);
            
        else
            BER_uncoded(ii,1)=Ber;
            SNR_uncoded(ii,1)=snr_db(ii);
            
        end

    end
    
    j=j+3;
end


figure('name','BER VS. SNR');
plot(SNR_coded,log10(BER_coded),'r');
hold all
plot(SNR_uncoded,log10(BER_uncoded),'g');
hold all
xlabel('SNR(DB)');
ylabel('BER');
