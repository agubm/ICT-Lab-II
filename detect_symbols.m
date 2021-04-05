function [ c_hat ] = detect_symbols( d_bar,constellation_order,switch_graph )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if constellation_order==2
    decision_points=[ -1.0000 - 1.0000i;-1.0000 + 1.0000i;1.0000 - 1.0000i; 1.0000 + 1.0000i];
elseif constellation_order==4
    decision_points=[ -0.9487 + 0.9487i; -0.9487 + 0.3162i; -0.9487 - 0.9487i; -0.9487 - 0.3162i;  -0.3162 + 0.9487i;  -0.3162 + 0.3162i;  -0.3162 - 0.9487i;  -0.3162 - 0.3162i;   0.9487 + 0.9487i;   0.9487 + 0.3162i;   0.9487 - 0.9487i;   0.9487 - 0.3162i;   0.3162 + 0.9487i;   0.3162 + 0.3162i;   0.3162 - 0.9487i; 0.3162 - 0.3162i];
elseif  constellation_order==6
    decision_points=[ -7.0000 - 7.0000i; -7.0000 - 5.0000i;  -7.0000 - 1.0000i;  -7.0000 - 3.0000i; -7.0000 + 7.0000i;  -7.0000 + 5.0000i;  -7.0000 + 1.0000i;  -7.0000 + 3.0000i;  -5.0000 - 7.0000i;  -5.0000 - 5.0000i;  -5.0000 - 1.0000i;  -5.0000 - 3.0000i;  -5.0000 + 7.0000i;  -5.0000 + 5.0000i;  -5.0000 + 1.0000i;  -5.0000 + 3.0000i;  -1.0000 - 7.0000i;  -1.0000 - 5.0000i;  -1.0000 - 1.0000i;  -1.0000 - 3.0000i;  -1.0000 + 7.0000i;  -1.0000 + 5.0000i;  -1.0000 + 1.0000i;  -1.0000 + 3.0000i;  -3.0000 - 7.0000i;  -3.0000 - 5.0000i;  -3.0000 - 1.0000i;  -3.0000 - 3.0000i;  -3.0000 + 7.0000i;  -3.0000 + 5.0000i;  -3.0000 + 1.0000i;  -3.0000 + 3.0000i;   7.0000 - 7.0000i;   7.0000 - 5.0000i;   7.0000 - 1.0000i;   7.0000 - 3.0000i;   7.0000 + 7.0000i;   7.0000 + 5.0000i;   7.0000 + 1.0000i;   7.0000 + 3.0000i;   5.0000 - 7.0000i;   5.0000 - 5.0000i;   5.0000 - 1.0000i;   5.0000 - 3.0000i;   5.0000 + 7.0000i;   5.0000 + 5.0000i;   5.0000 + 1.0000i;   5.0000 + 3.0000i;   1.0000 - 7.0000i;   1.0000 - 5.0000i;   1.0000 - 1.0000i;   1.0000 - 3.0000i;   1.0000 + 7.0000i;   1.0000 + 5.0000i;   1.0000 + 1.0000i;   1.0000 + 3.0000i;   3.0000 - 7.0000i;   3.0000 - 5.0000i;   3.0000 - 1.0000i;   3.0000 - 3.0000i;   3.0000 + 7.0000i;   3.0000 + 5.0000i;   3.0000 + 1.0000i;   3.0000 + 3.0000i];
end

nf = modnorm(decision_points,'avpow',1);
%decision_points =nf*decision_points;
d=d_bar/nf;

error = [];
c_hat_temp=[];
c_hat=[];
for i =1:length(d)
    for j=1:length(decision_points)
        error(j,1)=abs(d(i)-decision_points(j));
    end
    c_hat_temp(i,1) = find(error==min(error(:)))-1;
    c_hat = [c_hat; de2bi(c_hat_temp(i) ,constellation_order, 'left-msb')'];
end


if switch_graph                                                   
    figure = scatterplot(d_bar,1,0,'r.');                                                          
    hold on
    scatterplot(decision_points*nf,1,0,'k*',figure)
    title('Demodulation ouput')
    grid on
    axis([-1.5 1.5 -1.5 1.5]);
end

end
