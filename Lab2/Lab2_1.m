I=imread('D:\MATLAB\DIP\Q2_1_1.tif');
[height,width]=size(I);

Max=max(I);
Min=min(I);

if length(Max)~=1
    Max=max(Max);
end
if length(Min)~=1
    Min=min(Min);
end

x=Min:Max;
L=Max-Min+1;

numr=zeros(1,L);
cdf=zeros(1,L);
for i=1:L
    for m=1:height
        for n=1:width
            if I(m,n)==i+Min-1
                numr(i)=numr(i)+1;
            end
        end
    end
end

for j=1:L
    cdf(j)=sum(numr(1:j));
    
end

output=zeros(m,n);
for m=1:height
    for n=1:width
        output(m,n)=round(255*(cdf(I(m,n)-Min+1)-1)/(height*width-1));
    end
end

figure
bar(x,numr)
title('pdf of orignal image')
figure
bar(x,cdf)
title('cdf of orignal image')

figure
output=uint8(output);
imshow(output)


% figure
% imshow(I)
% figure
% histogram(I)
% figure
% imhist(I)
% figure
% histeq(I)