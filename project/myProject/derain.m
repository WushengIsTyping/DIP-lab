function output=derain(I)
%% detection (kernel regression method)
% step1: calculate the weight for q
% step2: convariance matrix Cp
% step3: SVD to Cp estimation
% step4: rain map
I=double(I);
[M,N]=size(I(:,:,1));
winS=9;
winL=(winS+1)/2; % from window center to window edge
sigD=3;
sigC=9;
k=0.1;

% RGB to luminance
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
Yp=0.2989*R+0.5870*G+0.1140*B;

% obtain gradients only the luminance values
[gx,gy]=gradient(Yp);

% Wp: 9*9
wd=zeros(winS,winS);
wc=zeros(winS,winS);
w=zeros(winS,winS);
thetaP=zeros(M,N);
lamdaP=zeros(M,N);
miuP=zeros(M,N);

t=cputime;
for i=winL:M-winL+1
    for j=winL:N-winL+1
        %Wp=Yp(i-winL+1:i+winL-1,j-winL+1:j+winL-1);
        Cp=zeros(2,2);
        Yp_ave=sum(sum(Yp(i-winL+1:i+winL-1,j-winL+1:j+winL-1)));
        for a=1:winS
            for b=1:winS
                wl=1/(1+exp(-k*(Yp(i-winL+a,j-winL+b)-Yp_ave)));
                wd(a,b)=exp(-((a-i)^2+(b-j)^2)/sigD^2);
                wc(a,b)=exp(-(I(i-winL+a,j-winL+b))/sigC^2);
                w(a,b)=wl*wd(a,b)*wc(a,b);
                num=winS*winS;
                gx0=gx(i-winL+a,j-winL+b);
                gy0=gy(i-winL+a,j-winL+b);
                Cp0=(1/num)*[gx0^2 gx0*gy0;gy0^2 gx0*gy0];
                Cp=Cp+Cp0;
            end
        end
        % 35.8s for this loop, how to make it quicker?
        % num=winS*winS;
        % gx0=gx(i-winL:i+winL,j-winL:j+winL);
        % gy0=gy(i-winL:i+winL,j-winL:j+winL);
        % Cp=(1/num)*[gx0.^2 gx0.*gy0;gy0.^2 gx0.*gy0];
        
        % use SVD to get angle and length of rain streak
        [U,S,V]=svd(Cp);
        thetaP(i,j)=acos(U(1,1));
        lamdaP(i,j)=S(1,1);
        miuP(i,j)=S(2,2);
    end
end

%% rain map
alpha=pi/6;
beta=2;
gama=10;
Map=zeros(M,N);
for m=1:M
    for n=1:N
        if abs(thetaP(m,n)-pi/2)<alpha && lamdaP(m,n)/miuP(m,n)>beta && miuP(m,n)>gama
            Map(m,n)=1;
        end  
    end
end

%% removal (nonlocal means filter) 
% step1: binary column vectors Rp,Rq
% step2: column vectors Bp,Bq
% step3: Ip estimation
e=cputime-t

output=Map;




