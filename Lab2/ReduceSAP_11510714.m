function [OutputImage]=ReduceSAP_11510714(InputImage,nsize)
[M,N]=size(InputImage);
m=nsize(1);
n=nsize(2);
a=(m-1)/2;
b=(n-1)/2;

g=InputImage;
for i=(a+1):(M-a)
    for j=(b+1):(N-b)
        win=InputImage((i-a:i+a),(j-b:j+b));
        med1=zeros(1,m);
        for x=1:m
            med1(x)=median(win(x,:));
        end
        med=median(med1);
        g(i,j)=med;
    end
end

OutputImage=g;
OutputImage((1:a),(1:b))=g(a+1,b+1);
OutputImage((1:a),(N-b+1:N))=g(a+1,N-b);
OutputImage((M-a+1:M),(1:b))=g(M-a,b+1);
OutputImage((M-a+1:M),(N-b+1:N))=g(M-a,N-b);
for i=(a+1):(M-a)
    OutputImage(i,(1:b))=g(i,b+1);
    OutputImage(i,(N-b:N))=g(i,N-b);
end
for j=(b+1):(N-b)
    OutputImage((1:a),j)=g(a+1,j);
    OutputImage((M-a:M),j)=g(M-a,j);
end

OutputImage=uint8(OutputImage);
figure
imshow(OutputImage)

