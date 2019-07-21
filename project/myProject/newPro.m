% main funtion for DIP project
I=imread('realWorld3.jpg');
I=double(I);
[M,N]=size(I(:,:,1));

%% detection (kernel regression method)
winS=9;
winL=(winS+1)/2; % from window center to window edge
sigD=3;
sigC=9;
k=0.1;

% RGB to luminance
R=I(:,:,1);
G=I(:,:,2);
B=I(:,:,3);
%Yp=0.2989*R+0.5870*G+0.1140*B;
Yp=0.3*R+0.6*G+0.1*B;

% obtain gradients only the luminance values
[gx,gy]=gradient(Yp);
gx=gx*(255/max(max(abs(gx))));
gy=gy*(255/max(max(abs(gy))));

% Wp: 9*9
w=zeros(winS,winS);
%Cp0=cell(9);
Cp0=ones(winS,4);
thetaP=zeros(M,N);
lamdaP=zeros(M,N);
miuP=zeros(M,N);

t=cputime;
for i=winL:M-winL+1
    for j=winL:N-winL+1
        %Wp=substrate(i-winL+1:i+winL-1,j-winL+1:j+winL-1);
        Cp=zeros(2,2);
        Yp_ave=sum(sum(Yp(i-winL+1:i+winL-1,j-winL+1:j+winL-1)))/winS^2;
        %count=1;
        for a=1:winS
            for b=1:winS
                wl=1/(1+exp(-k*(Yp(i-winL+a,j-winL+b)-Yp_ave)));
                wd=exp(-((a-winL)^2+(b-winL)^2)/sigD^2);
                wc=exp(-sum((I(i-winL+a,j-winL+b,:)-I(i,j,:)).^2)/sigC^2);
                w(a,b)=wl*wd*wc;
                gx0=gx(i-winL+a,j-winL+b);
                gy0=gy(i-winL+a,j-winL+b);             
                Cp0=[gx0^2 gx0*gy0;gx0*gy0 gy0^2];
                Cp1=w(a,b)^2*Cp0;
                Cp=Cp+Cp1;
            end
        end
        % use SVD to get angle and length of rain streak
        Zp=sum(sum(w.^2));
        [U,S,V]=svd((1/Zp)*Cp);
        thetaP(i,j)=acos(U(2,1));
        lamdaP(i,j)=S(1,1);
        miuP(i,j)=S(2,2);
    end
end

%% rain map
alpha=pi/6;
beta=4;
gama=10;
Map=zeros(M,N);
for m=1:M
    for n=1:N
        if abs(thetaP(m,n)-pi/2)<alpha && lamdaP(m,n)/miuP(m,n)>beta && miuP(m,n)>gama
            Map(m,n)=1;
        end  
    end
end

e=cputime-t

% figure
% imshow(uint8(I))
% hold on
% contour(Map)


%% removal (nonlocal means filter) 
f=7;
t=25;
sigma=15;
psize=2*f+1;
nsize=50;
NewMap=1-Map;
Ies1=I;
a=21;
b=21;

% Ies(:,:,1)=my_nlm(R,NewMap,t,f);
% Ies(:,:,2)=my_nlm(G,NewMap,t,f);
% Ies(:,:,3)=my_nlm(B,NewMap,t,f);

% t=cputime;
% 
% SA_R=im2col(R,[nsize nsize]);
% SA_G=im2col(G,[nsize nsize]);
% SA_B=im2col(B,[nsize nsize]);
% SA_Map=im2col(NewMap,[nsize nsize]);
% for s=1:length(SA_R(1,:))
%     S_R=resample(SA_R(:,s),nsize,nsize);
%     S_G=resample(SA_G(:,s),nsize,nsize);
%     S_B=resample(SA_B(:,s),nsize,nsize);
%     S_Map=im2col(SA_Map(:,s),nsize,nsize);
%     
%     patch_R=im2col(S_R,[psize psize]); % 225*2500
%     patch_G=im2col(S_G,[psize psize]);
%     patch_B=im2col(S_B,[psize psize]);
%     patch_Map=im2col(S_Map,[psize psize]);
% end
% e=cputime-t

% patch_R=SA_R.*SA_Map;
% patch_G=SA_G.*SA_Map;
% patch_B=SA_B.*SA_Map;


% t=cputime;
for m=1:M
    for n=1:n
        if Map(m,n)==1
            try
%               Ies(m,n,1)=median(I(m-a:m+a,n-b:n+b,1));
%               Ies(m,n,2)=median(I(m-a:m+a,n-b:n+b,2));
%               Ies(m,n,3)=median(I(m-a:m+a,n-b:n+b,3));
                win1=I(m-a:m+a,n-b:n+b,1).*NewMap(m-a:m+a,n-b:n+b);
                win2=I(m-a:m+a,n-b:n+b,2).*NewMap(m-a:m+a,n-b:n+b);
                win3=I(m-a:m+a,n-b:n+b,3).*NewMap(m-a:m+a,n-b:n+b);
                
                Ies1(m,n,1)=sum(sum(win1(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
                Ies1(m,n,2)=sum(sum(win2(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
                Ies1(m,n,3)=sum(sum(win3(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
            catch
            warning('Too close to the edge.');
            end
        end
    end
end


% for m=f+1:M-nsize-f+1 % similarity area左上角的点的位置范围
%     for n=f+1:N-nsize-f+1
%         
%         for a=1:nsize % 50
%             for b=1:nsize
%                 if Map(m+a-1,n+b-1)==1
%                     Norm=zeros(nsize,nsize);
%                     unNorm1=zeros(nsize,nsize);
%                     unNorm2=zeros(nsize,nsize);
%                     unNorm3=zeros(nsize,nsize);
%                     for c=1:nsize
%                         for d=1:nsize
%                             cal=NewMap(m+a-1,n+b-1)*NewMap(m+c-1,n+d-1);
%                             Bp=I(m-f+a-1:m+f+a-1,n-f+b-1:n+f+b-1,:).*cal;
%                             Bp=Bp(:);
%                             Bq=I(m-f+c-1:m+f+c-1,n-f+d-1:n+f+d-1,:).*cal;
%                             Bq=Bq(:);
%                             par1=exp(-sum((Bp-Bq).^2)/sigma^2);
%                             par2=NewMap(m+c-1,n+d-1);
%                             Norm(c,d)=par1*par2;
%                             unNorm1(c,d)=par1*par2*I(m+c-1,n+d-1,1);
%                             unNorm2(c,d)=par1*par2*I(m+c-1,n+d-1,2);
%                             unNorm3(c,d)=par1*par2*I(m+c-1,n+d-1,3);
%                         end
%                     end
%                     Ies(m+a-1,n+b-1,1)=sum(sum(unNorm1))/sum(sum(Norm));
%                     Ies(m+a-1,n+b-1,2)=sum(sum(unNorm2))/sum(sum(Norm));
%                     Ies(m+a-1,n+b-1,3)=sum(sum(unNorm3))/sum(sum(Norm));
%                 end
%             end
%         end
%     end
% end
e=cputime-t

% figure;imshow(uint8(Ies))