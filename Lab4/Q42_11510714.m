% Q42_11510714
I=imread('Q4_2.tif');
InputImage=double(I);
[M,N]=size(InputImage);
%fp=padarray(InputImage,[M/2,N/2]); % padded image
cent=ones(M,N);
for i=1:M
    for j=1:N
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
G=fft2(InputImage.*cent);


%% full inverse filter
k=0.0025;
H=zeros(M,N);
for u=1:M
    for v=1:N
        H(u,v)=exp(-k*((u-M/2)^2+(v-N/2)^2)^(5/6));
    end
end

F1=G./H;
opt=real(ifft2(F1));
OutputImage=rescale(opt,0,255);

figure
subplot 321
imshow(I)
title('Orignal Image')
subplot 322
imshow(uint8(abs(G)))
title('Frequency Domain')
subplot 323
histogram(I)
subplot 324
imshow(uint8(OutputImage))
title('Output Image of Full Inverse')
        
%% radially limited inverse
 uk=0;
 vk=0;
 D=zeros(M,N);
 Di=zeros(M,N);
 H_B=zeros(M,N);
 n=10;
 D0=50;
 for i=1:M
     for j=1:N
         D(i,j)=sqrt((i-M/2-uk)^2+(j-N/2-vk)^2);
         Di(i,j)=sqrt((i-M/2+uk)^2+(j-N/2+vk)^2);
         H_B(i,j)=(1/(1+(D0/D(i,j)).^(2*n)))*(1/(1+(D0/Di(i,j)).^(2*n)));
     end
 end
 H_Lp=1-H_B;
 F2=F1.*H_Lp;
 H_Lp=rescale(H_Lp,0,255);
opt2=real(ifft2(F2).*cent);
OutputImage2=rescale(opt2,0,255);

subplot 325
imshow(uint8(OutputImage2))
title('After Butterworth Lowpass Filter')

%% Wiener filtering
K=0.0004;
Fabs=conj(H).*H;
F3=(1./H).*(Fabs./(Fabs+K)).*G;
% F3=zeros(M,N);
% for u=1:M
%     for v=1:N
%         F3(u,v)=((abs(H(u,v))^2)/(H(u,v)*(abs(H(u,v))^2)+K))*G(u,v);
%     end
% end
opt3=real(ifft2(F3).*cent);
OutputImage3=rescale(opt3,0,255);

subplot 326
imshow(uint8(OutputImage3))
title('Wiener filtering')

        
        
        
        
        
        