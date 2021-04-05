function [ b_hat ] = decode_hamming( c_hat,parity_check_matrix,n_zero_padded_bits,switch_off )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

c_hat=c_hat(1:length(c_hat)-n_zero_padded_bits,1);
if switch_off==0
    b_hat=[];
for i=1:7:length(c_hat)
    if length(c_hat)>=i %to check if there are still 7 bit avail
        c_temp=c_hat(i:i+6);
        syndrome=parity_check_matrix*c_temp;
        syndrome=mod(syndrome,2); %generate syndrome vector
            for j=1:length(parity_check_matrix)
                %check if the syndrom vector corresponds to a column in the
                %parity matrix and correct the bit for the corresponding
                %column
                if (parity_check_matrix(:,j)==syndrome) 
                    c_temp(j)=not(c_temp(j));
                   
                    %do nothing to the bit if syndrome is null
                else
                    c_temp(j)=c_temp(j);
                end
            end
        end
        %store the corrected c in b_hat_temp
        b_hat_temp(i:i+6)=c_temp;
end
       b_hat_temp=b_hat_temp';
       
 %Pick the first 4 bits in each group of 7 since those are the transmitted
 %bits
for k=1:7:length(c_hat)
    b_hat=[b_hat;b_hat_temp(k:k+3)];
end

%No channel Decoding it the bit is off
else
    b_hat= c_hat;
end

end

