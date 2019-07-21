% new de-rain
I=imread('mountain.jpg');
I=double(I);
[M,N]=size(I(:,:,1));
figure
imshow(uint8(I))

winS=9;
winL=(winS+1)/2; % from window center to window edge
sigD=3;
sigC=9;
k=0.1;

R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
Yp=0.2989*R+0.5870*G+0.1140*B;

[gx,gy]=gradient(Yp);

gx2=gx.^2;
gy2=gy.^2;
gxy=gx.*gy;

wd=zeros(winS,winS);
wc=zeros(winS,winS);
for i=winL:M-winL+1
    for j=winL:N-winL+1
        %Wp=Yp(i-winL+1:i+winL-1,j-winL+1:j+winL-1);
%        Cp=zeros(2,2);
        Yp_ave=sum(sum(Yp(i-winL+1:i+winL-1,j-winL+1:j+winL-1)));
        for a=1:winS
            for b=1:winS                
%                 wl=1/(1+exp(-k*(Yp(i-winL+a,j-winL+b)-Yp_ave)));
                 wd(a,b)=exp(-((a-i)^2+(b-j)^2)/sigD^2);
                 wc(a,b)=exp(-(I(i-winL+a,j-winL+b))/sigC^2);
            end
        end
    end
end

wl=1./(1+exp(-k*(Yp-Yp_ave)));
w(a,b)=wl*wd(a,b)*wc(a,b);