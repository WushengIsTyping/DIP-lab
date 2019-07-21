% Q433_11510714
% salt-and-pepper and shaking
I=imread('Q4_3_3.tiff');
InputImage=double(I);
[M,N]=size(InputImage);
cent=ones(M,N);
for i=1:M
    for j=1:N
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
F=fft2(InputImage.*cent);

a=0.1;
b=0.1;
T=1;
H=zeros(M,N);
for u=1:M
    for v=1:N
        con=u*a+v*b;
        H(u,v)=(T/pi/(con))*sin(pi*(con))*exp(-1j*pi*con);
    end
end

K=0.000000004;
Fabs=conj(H).*H;
F2=(1./H).*(Fabs./(Fabs+K)).*F;

F3=zeros(M,N);
for u=1:M
    for v=1:N
        F3(u,v)=((abs(H(u,v))^2)/(H(u,v)*(abs(H(u,v))^2)+K))*F(u,v);
    end
end

opt3=real(ifft2(F2).*cent);
OutputImage1=rescale(opt3,0,255);

win2=[3,3];
a=(win2(1)-1)/2;
b=(win2(2)-1)/2;
fp2=padarray(OutputImage1,[a,b]);
f2=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        win=fp2((i-a:i+a),(j-b:j+b));
        f2(i,j)=1/2*(max(max(win))+min(min(win)));
    end
end
OutputImage2=uint8(f2);

figure
subplot 221
imshow(I)
subplot 222
imshow(uint8(10*log2(1+abs(F))))
subplot 223
imshow(uint8(OutputImage1))
subplot 224
imshow(uint8(OutputImage2))