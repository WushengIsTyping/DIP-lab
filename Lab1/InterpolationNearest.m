function output_file=InterpolationNearest(input_file,dim)
y=length(input_file(1,:)); % length of orignal image
x=length(input_file(:,1)); % width of orignal image

% considering the coordinate of a pixel, we treat them as separate points
% and n points means (n-1) intervals, so minus 1
% rounding starts form 0, but array starts from 1, so plus 1
for i=1:dim(1)
    for j=1:dim(2)
        output_file(i,j)=input_file(round((x-1)*((i-1)/dim(1))+1),round((y-1)*((j-1)/dim(2))+1));
    end
end

