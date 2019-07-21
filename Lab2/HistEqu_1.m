function [OutputImage,InputHist,OutputHist]=HistEqu_11510714(InputImage)
[height,width]=size(InputImage);
L=256;

% InputHist
InputHist=zeros(1,256);
for i=1:L
    for m=1:height
        for n=1:width
            if InputImage(m,n)==i
                InputHist(i)=InputHist(i)+1;
            end
        end
    end
end

% cdf
cdf=zeros(1,256);
for j=1:L
    cdf(j)=sum(InputHist(1:j));
end

% OutputImage
OutputImage=zeros(m,n);
for m=1:height
    for n=1:width
        OutputImage(m,n)=round(255*(cdf(InputImage(m,n))-1)/(height*width-1));
    end
end

% OutputHist
OutputHist=zeros(1,256);
for i=1:L
    for m=1:height
        for n=1:width
            if OutputImage(m,n)==i
                OutputHist(i)=OutputHist(i)+1;
            end
        end
    end
end

n=0:255;
figure
bar(n,InputHist)
title('pdf of orignal image')
figure
bar(n,OutputHist)
title('pdf of new image')
figure
OutputImage=uint8(OutputImage);
imshow(OutputImage)

