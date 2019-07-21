% simple salt noise
% Contra harmonic mean filter
I=imread('Q4_1_2.tiff');
InputImage=double(I);
[M,N]=size(InputImage);
fp=padarray(InputImage,[M/2,N/2]); % padded image

cent=ones(M*2,N*2);
for i=1:M*2
    for j=1:N*2
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
F=fft2(fp.*cent);

% contraharmonic mean filter with Q <0
win=[3,3];
a=(win(1)-1)/2;
b=(win(2)-1)/2;
fp=padarray(InputImage,[a,b]);
f=zeros(M,N);
Q=-1;
for i=a+1:M+a
    for j=b+1:N+b
        win=fp((i-a:i+a),(j-b:j+b));
        f(i,j)=sum(sum(win.^(Q+1)))/sum(sum(win.^Q));
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