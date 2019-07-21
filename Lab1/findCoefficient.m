% find coefficient of bilinear
dim=[5 5];
x=4; y=4;
x1=[];x2=[];y1=[];y2=[];

Y=[];
for i=1:y
    for j=1:dim(1)
    %for j=2:dim(1)-1
        y1=floor((i-1)*(y-1)/(dim(1)-1))+1;
        y2=ceil((i-1)*(y-1)/(dim(1)-1))+1;
        % dim(1)*y ºá×ø±ê
        Y(i,j)=input_file(x1,i)*(x2-j)/(x2-x1)...
            +input_file(x2,i)*(j-x1)/(x2-x1);
    end
end

for m=1:dim(2)
    for n=2:dim(1)-1
        y1=floor((i-1)*(y-1)/(dim(1)-1))+1;
        y2=ceil((i-1)*(y-1)/(dim(1)-1))+1;
        output_file(m,n)
        x1=floor((i-1)*(x-1)/(dim(1)-1))+1;
        x2=ceil((i-1)*(x-1)/(dim(1)-1))+1;
        Y(i,j)=input_file(x1,i)*(x2-j)/(x2-x1)...
            +input_file(x2,i)*(j-x1)/(x2-x1);



for i=1:dim(1)
    for j=1:dim(2)
        x1(i)=floor((i-1)*(x-1)/(dim(1)-1))+1;
        x2(i)=ceil((i-1)*(x-1)/(dim(1)-1))+1;
        y1(j)=floor((j-1)*(y-1)/(dim(2)-1))+1;
        y2(j)=ceil((j-1)*(y-1)/(dim(2)-1))+1;
%         output_file(i,j)=(input_file(x1,y1)*(x2-i)*(y2-j)...
%             +input_file(x2,y1)*(i-x1)*(y2-j)...
%             +input_file(x1,y2)*(x2-i)*(j-y1)...
%             +input_file(x2,y2)*(i-x1)*(j-y1)...
%             )/(x2-x1)/(y2-y1);
    end
end