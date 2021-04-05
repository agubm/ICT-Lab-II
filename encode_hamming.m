function [c] = encode_hamming(b,parity_check_matrix,n_zero_padded_bits,switch_off )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

if switch_off ==0
    [ee ff]= size(parity_check_matrix);
    arb_paritymat= parity_check_matrix(1:ee, 1:ff-ee);
    par_G=[eye(ff-ee) arb_paritymat'];
    N=length(b)/4;
    b_reshape=reshape(b,[4,N]);
    b_reshape=b_reshape';
    
    b_coded=b_reshape*par_G;
    b_coded=mod(b_coded,2);
    b_final=b_coded';
    N2=7*N;
    c_temp=reshape(b_final,[N2,1]);
    
    c=[c_temp;zeros(n_zero_padded_bits,1)];
    
else
    c=[b;zeros(n_zero_padded_bits,1)];
    
end


end

