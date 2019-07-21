function [OutputImageL,OutputImageH]=Gaussian_11510714(InputImage,D0)
InputImage=double(InputImage);
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
I_GLPF=zeros(2*M,2*N);
for u=1:2*M
    for v=1:2*N
        D=((u-M)^2+(v-N)^2)^(1/2);
        I_GLPF(u,v)=exp(-D^2/(2*D0^2));
    end
end
oneArr=ones(2*M,2*N);
I_GHPF=oneArr-I_GLPF;

G_L=F.*I_GLPF;
G_H=F.*I_GHPF;
g_l=real(ifft2(G_L)).*cent;
g_h=real(ifft2(G_H)).*cent;
OutputImageL=g_l(M/2+1:3*M/2+1,N/2+1:3*N/2+1);
OutputImageH=g_h(M/2+1:3*M/2+1,N/2+1:3*N/2+1);

figure
subplot 321
imshow(uint8(InputImage))
title('Input Image')
subplot 322
imshow(uint8(real(F)))
title('Frequency Domain of Input Image')
subplot 323
imshow(uint8(real(G_L)))
title('Filtered by Lowpass Filter')
subplot 324
imshow(uint8(OutputImageL))
title('Lowpass Filtered Output Image')
subplot 325
imshow(uint8(imag(G_H)))
title('Filtered by Highpass Filter')
subplot 326
imshow(uint8(OutputImageH))
title('Highpass Filtered Output Image')


