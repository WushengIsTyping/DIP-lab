function output_file=InterpolationBilinear(input_file,dim)
x=length(input_file(:,1)); % length of orignal image
y=length(input_file(1,:));  % width of orignal image

% I divided it into two steps
%% 
% first is to get all the edges and some of the intersection points
% we get a matrix of size dim(1)*y,the width of new image and length of original image
% and to make this step clearer, I calculated the coordinate first
% x0 is the coordinate of interpolated point on the orignal scale
% x1 and x2 are the two pixels surrounding x0 on the orignal image
% get the value in base using the surrounding points value and there linearity

base=[];
for i=1:y
    for j=2:dim(1)-1
        x0=(j-1)*(x-1)/(dim(1)-1)+1;
        x1=floor(x0);
        x2=ceil(x0);
        base(j,i)=input_file(x1,i)+(x0-x1)*(input_file(x2,i)-input_file(x1,i))/(x2-x1);
    end
end
base(1,:)=input_file(1,:);
base(dim(1),:)=input_file(x,:);
% we can get the edge directly from the orignal image
%%
% the second step is similar to the first step
% and we also need to consider the coincieded columns 

for m=1:dim(1)
    for n=2:dim(2)-1
        y0=(n-1)*(y-1)/(dim(2)-1)+1;
        y1=floor(y0);
        y2=ceil(y0);
        if y1~=y2
            output_file(m,n)=base(m,y1)+(y0-y1)*(base(m,y2)-base(m,y1))/(y2-y1);
        else
            output_file(m,n)=base(m,y1);
        end
    end
end
output_file(:,1)=base(:,1);
output_file(:,dim(2))=base(:,y);
