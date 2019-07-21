I=imread('T1_2.tif');
[M,N]=size(I);
mat1=[0 1 0;1 -4 1;0 1 0];
mat2=[1 1 1;1 -8 1;1 1 1];
I1=padarray(I,[1,1]);
lap1=zeros(M,N);
lap2=zeros(M,N);
blur=zeros(M,N);
for i=2:M+1
    for j=2:N+1
        win=double(I1((i-1:i+1),(j-1:j+1)));
        win1=win.*mat1;
        win2=win.*mat2;
        blur(i-1,j-1)=round(sum(sum(win)/9));
        lap1(i-1,j-1)=sum(sum(win1));
        lap2(i-1,j-1)=sum(sum(win2));
    end
end

lap1=lap1+128*ones(M,N);
lap2=lap2+128*ones(M,N);
InputImage=double(I);
mask1=InputImage-lap1;
mask2=InputImage-lap2;
OutputImage1=InputImage+mask1;
OutputImage2=InputImage+mask2;
OutputImage1=uint8(OutputImage1);
OutputImage2=uint8(OutputImage2);
figure
subplot 221
imshow(OutputImage1)
title('-4 in the center')
subplot 223
imshow(uint8(lap1))
title('-4 in the center')
subplot 222
imshow(OutputImage1)
title('-8 in the center')
subplot 224
imshow(uint8(lap1))
title('-8 in the center')
