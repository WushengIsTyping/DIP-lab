I=imread('T1_1.tif');
[M,N]=size(I);
I1=padarray(I,[1,1]);
mat1=[-1 -1 -1;-1 8 1;-1 -1 -1];
mat2=[-1 -2 -1;0 0 0;1 2 1];
mat3=[-1 0 1;-2 0 2;-1 0 1];
I1=double(I1);
sob=zeros(M,N);
lap1=zeros(M,N);
for i=2:M+1
    for j=2:N+1
        win=I1((i-1:i+1),(j-1:j+1));
        win1=win.*mat1;
        win2=win.*mat2;
        win3=win.*mat3;
        sob(i-1,j-1)=abs(sum(sum(win2)))+abs(sum(sum(win3)));
        lap1(i-1,j-1)=sum(sum(win1));
    end
end
lap2=lap1+128*ones(M,N);
OutputImage1=double(I)+lap1;

I2=padarray(sob,[2,2]);
blur=zeros(M,N);
for i=3:M+2
    for j=3:N+2
        win=double(I2((i-2:i+2),(j-2:j+2)));
        blur(i-2,j-2)=round(sum(sum(win)/25));
    end
end

mask=OutputImage1.*blur;
outG=double(I)+mask;
output=round(outG.^0.5);

figure
subplot 221
imshow(I)
title('original image')
subplot 222
imshow(uint8(lap2))
title('Laplacian')
subplot 223
imshow(uint8(OutputImage1))
title('output image')
subplot 224
imshow(uint8(sob))
title('sobel gradient')

figure
subplot 221
imshow(uint8(blur))
title('blurred image')
subplot 222
imshow(uint8(mask))
title('Mask')
subplot 223
imshow(uint8(outG))
title('output g')
subplot 224
imshow(uint8(output))
title('final output')