% salt-and-pepper noise
% median
I=imread('Q4_1_3.tiff');
InputImage=double(I);
[M,N]=size(InputImage);
fp=padarray(InputImage,[round(M/2),round(N/2)]); % padded image

cent=ones(size(fp));
for i=1:M*2
    for j=1:N*2
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
F=fft2(fp.*cent);

% median filter
win=[5,5];
a=(win(1)-1)/2;
b=(win(2)-1)/2;
fp=padarray(InputImage,[a,b]);

f=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        win=fp((i-a:i+a),(j-b:j+b));
        f(i,j)=median(median(win));
    end
end
OutputImage=uint8(f);

figure
subplot 221
imshow(uint8(I))
title('Input Image')
subplot 222
imshow(uint8(10*log2(1+abs(F))))
title('Frequency Domain')
subplot 223
histogram(I)
title('Input Image Histogram')
subplot 224
imshow(OutputImage)
title('Output Image')