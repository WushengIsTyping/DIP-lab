function Q32_11410292(input,D)
f=input;
f=im2double(f);

[X, Y]=size(f);
F=fft2(f);
F=fftshift(F);
H1=zeros(size(F));
H2=zeros(size(F));
D0=D;
for i=1:X
    for j=1:Y
            H1(i,j)=exp(-1*((i-X/2).^2+(j-Y/2).^2)/(2*D0.^2));
            H2(i,j)=1-exp(-1*((i-X/2).^2+(j-Y/2).^2)/(2*D0.^2));
    end
end
G1=F.*H1;
G2=F.*H2;
%gp1=real(ifft2(G1));
%gp2=real(ifft2(G2));
%G1=fftshift(F).*H1;
%G2=fftshift(F).*H2;
gp1=real(ifft2(fftshift(G1)));
gp2=real(ifft2(fftshift(G2)));
figure;imshow(uint8(gp1),[]),title('GLPF');
figure;imshow(uint8(gp2),[]),title('GHPF');