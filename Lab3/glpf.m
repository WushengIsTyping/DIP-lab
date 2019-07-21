function g=glpf(f,D0)
%f=imread(f);
[M,N]=size(f);
F=fft2(double(f));
u=0:M-1;
v=0:N-1;
idx=find(u>M/2);
u(idx)=u(idx)-M;
idy=find(v>N/2);
v(idy)=v(idy)-N;
[V,U]=meshgrid(v,u);
D=sqrt(U.^2+V.^2);
H=exp(-(D.^2)./(2*(D0^2)));
G=H.*F;
g=real(ifft2(double(G)));
imshow(g,[]);
