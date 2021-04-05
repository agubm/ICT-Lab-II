function [b] = generate_frame( frame_size,switch_graph )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

b = randi([0 1],frame_size,1);

if switch_graph ==1
    figure(1)
    stem(b);
    title('Information/ Input bits')
end

end

