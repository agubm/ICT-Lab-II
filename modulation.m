function [d] = modulation(c,switch_mod,switch_graph)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here



if switch_mod==0
    bps=2;
elseif switch_mod==1
    bps=4;
else
    bps=6;
end

M=power(2,bps);

refconst = qammod(0:M-1,M);
nf = modnorm(refconst,'avpow',1);
c_mod=vec2mat(c,bps);
d_temp=bi2de(c_mod,'left-msb');
d_scale=qammod(d_temp,M,'gray');
%d_scale=qammod(d_temp,M,0,'gray','UnitAveragePower',true);
d=nf*d_scale;

if(switch_graph == 1)
    scatterplot(d,1,0,'bo');
    title('Modulation Output');
    grid on
    axis([-1.5 1.5 -1.5 1.5]);
end


  

end

