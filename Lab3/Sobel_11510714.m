function OutputImage=Sobel_11510714(InputImage)
%% frequency domain filtering
InputImage=double(InputImage);
[M,N]=size(InputImage);
fp=padarray(InputImage,[1,1]); % padded image

sob=zeros(M+2,N+2);
sob(M/2+1:M/2+3,N/2+1:N/2+3)=[-1 0 1;-2 0 2;-1 0 1];

cent=ones(M+2,N+2);
for i=1:M+2
    for j=1:N+2
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end

F=fft2(fp.*cent);
SOB=fft2(sob.*cent);
H=imag(SOB).*cent;
G=F.*H;
gp=imag(ifft2(G)).*cent;
OutputImage=gp(1:M,1:N);

figure
subplot 221
imshow(uint8(InputImage))
title('Input Image')
subplot 222
imshow(uint8(10*log2(1+abs(F))))
title('Frequency Domain')
subplot 223
imshow(uint8((H+8)*255/16))
title('H')
subplot 224
imshow(uint8(OutputImage))
title('Output Image')

%% spacial filtering
I1=padarray(InputImage,[1,1]);
mat=[-1 0 1;-2 0 2;-1 0 1];
lap=zeros(M,N);
for i=2:M+1
    for j=2:N+1
        win=I1((i-1:i+1),(j-1:j+1));
        win1=win.*mat;
        lap(i-1,j-1)=sum(sum(win1));
    end
end
OutputImageS=InputImage+lap;
figure
imshow(uint8(OutputImageS))
title('spatial filtered')

