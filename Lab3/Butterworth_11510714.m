function OutputImage=Butterworth_11510714(InputImage,D0)
InputImage=double(InputImage);
[M,N]=size(InputImage);
fp=padarray(InputImage,[M/2,N/2]);
cent=ones(M*2,N*2);
for i=1:M*2
    for j=1:N*2
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
F=fft2(fp.*cent);
uk = [80,160,80,160]; % coordinates compared to center
vk = [55,55,-55,-55]; 

D=zeros(M*2,N*2);
Di=zeros(M*2,N*2);
Hi=zeros(M*2,N*2);
H=ones(M*2,N*2);
n=4; % filter order
for k=1:4
    for u=1:M*2
        for v=1:N*2
            D(u,v)=sqrt((u-M-uk(k))^2+(v-N-vk(k))^2);
            Di(u,v)=sqrt((u-M+uk(k))^2+(v-N+vk(k))^2);
            Hi(u,v)=(1/(1+(D0/D(u,v)).^(2*n)))*(1/(1+(D0/Di(u,v)).^(2*n)));
        end
    end
    H=H.*Hi;
end

G=F.*H;
gp=abs(ifft2(G));
OutputImage=gp(M/2+1:3*M/2+1,N/2+1:3*N/2+1);

figure
subplot 221
imshow(uint8(InputImage))
title('Input Image')
subplot 222
imshow(uint8(10*log2(1+abs(F))))
title('Frequency Domain')
subplot 223
imshow(uint8(10*log2(1+abs(G))))
title('Filtered Frequency Domain')
subplot 224
imshow(uint8(OutputImage))
title('Output Image')

