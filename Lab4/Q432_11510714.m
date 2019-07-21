% Q432_11510714
% salt-and-pepper and shaking
I=imread('Q4_3_2.tiff');
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
F0=fft2(InputImage.*cent);

%% Alpha-trimmed mean filter
win=[9,9];
a=(win(1)-1)/2;
b=(win(2)-1)/2;
fp=padarray(InputImage,[a,b]);
d=80;
f=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        window=fp((i-a:i+a),(j-b:j+b));
        win1=reshape(window,[win(1),win(2)]);
        Rank=sort(window);
        f(i,j)=(1/(win(1)*win(2)-d))*(sum(sum(window))-sum(Rank(1:d/2))-sum(Rank(end-d/2+1:end)));
    end
end
OutputImage1=f(a+1:end,b+1:end);

% win=[5,5];
% a=(win(1)-1)/2;
% b=(win(2)-1)/2;
% fp=padarray(InputImage,[a,b]);
% f=zeros(M,N);
% for i=a+1:M+a
%     for j=b+1:N+b
%         win=fp((i-a:i+a),(j-b:j+b));
%         f(i,j)=median(median(win));
%     end
% end
% OutputImage1=f(a+1:end,b+1:end);

%% Wiener-shaking
F=fft2(OutputImage1.*cent);
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

K=0.0000007; % 4e-7
Fabs=conj(H).*H;
F2=(1./H).*(Fabs./(Fabs+K)).*F;

opt3=real(ifft2(F2).*cent);
OutputImage=rescale(opt3,0,255);
OutputImage=histeq(uint8(OutputImage));
%%
win=[7,7];
a=(win(1)-1)/2;
b=(win(2)-1)/2;
fp2=padarray(OutputImage,[a,b]);
f2=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        win=fp2((i-a:i+a),(j-b:j+b));
        f2(i,j)=mean(mean(win));
    end
end
OutputImage2=f2(a+1:end,b+1:end);
OutputImage3=(OutputImage2-80)*255/90;

%% display
figure
subplot 221
imshow(I)
subplot 222
imshow(uint8(10*log2(1+abs(F0))))
subplot 223
imshow(uint8(OutputImage1))
subplot 224
imshow(uint8(OutputImage3))