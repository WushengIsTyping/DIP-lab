function [OutputImage, OutputHist, InputHist] = LocalHistEqu_11510714(InputImage, mSize)
% the input mSize must be odd
[M,N]=size(InputImage);
m1=mSize(1);
m2=mSize(2);

InputHist=zeros(1,256);
for m=1:M
    for n=1:N
        InputHist(InputImage(m,n)+1)=InputHist(InputImage(m,n)+1)+1;
    end
end

res1=(m1-1)/2;
res2=(m2-1)/2;
B=padarray(InputImage,[res1,res2]);
for i=(1+res1):(M-res1*2)
    for j=(1+res2):(N-res2*2)
        win=InputImage((i-res1:i+res1),(j-res2:j+res2));
        pdf=zeros(1,256);
        for a=1:m1
            for b=1:m2
                pdf(win(a,b)+1)=pdf(win(a,b)+1)+1;
            end
        end
        cdf=zeros(1,256);
        for k=1:256
            cdf(k)=round(255*sum(pdf(1:k))/m1/m2);
        end
        B(i,j)=cdf(win(1+res1,1+res2)+1);
    end
end
        
OutputImage=uint8(B((res1+1:res1+M),(res2+1:res2+N)));

OutputHist=zeros(1,256);
for m=1:M
    for n=1:N
        OutputHist(OutputImage(m,n)+1)=OutputHist(OutputImage(m,n)+1)+1;
    end
end

figure
imshow(OutputImage)
figure
bar(InputHist)
title('Input Histogram')
figure
bar(OutputHist)
title('Output Histogram')
