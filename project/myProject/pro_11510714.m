% main funtion for DIP project
I=imread('rain3.jpg');
I=double(I);
[M,N]=size(I(:,:,1));

%% detection (kernel regression method)
% step1: calculate the weight for q
% step2: convariance matrix Cp
% step3: SVD to Cp estimation
% step4: rain map
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
% gx=rescale(gx,-255,255);
% gy=rescale(gy,-255,255);

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
                %Cp0(count,:)=[gx0^2 gx0*gy0 gx0*gy0 gy0^2];
                %count=count+1;                
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

figure
imshow(uint8(I))
title('Input Image')
figure
imshow(uint8(I))
hold on
contour(Map)
title('Rain Map')



%% removal (nonlocal means filter) 
% step1: binary column vectors Rp,Rq
% step2: column vectors Bp,Bq
% step3: Ip estimation
% non local means filter
% block Bp and Bq is 15*15
% nonlocal neighbors is 50*50

f=7;
sigma=15;
psize=2*f+1;
nsize=50;
NewMap=1-Map;

% t=cputime;
% for m=1+f:M-nsize-f % similarity area
%     for n=1+f:N-nsize-f
%         % RGB of all possible patches in similarity area
%         % every column of P_R is all R values in a patch
%         % (1:psize,1) -> (1:psize,psize)
%         % how many columns P_R has, then how many p and q
%         P_R=im2col(R(m-f:m+nsize-1+f,n-f:n+nsize-1+f),[psize psize]); 
%         P_G=im2col(G(m-f:m+nsize-1+f,n-f:n+nsize-1+f),[psize psize]);
%         P_B=im2col(B(m-f:m+nsize-1+f,n-f:n+nsize-1+f),[psize psize]);
%         % 1-M of all possible patches
%         P_Map=im2col(NewMap(m-f:m+nsize-1+f,n-f:n+nsize-1+f),[psize psize]);
%         pos=length(P_R(1,:)); % 50*50
%         %Ies=cell(M,N,3);
%         Ies=I;
%         for p=1:pos
%             newB=repmat(P_Map(:,p),1,pos).*(P_Map); %(1-Rp)*(1-Rq)
%             P_R_p=repmat(P_R(:,p),1,pos).*newB;
%             P_G_p=repmat(P_G(:,p),1,pos).*newB;
%             P_B_p=repmat(P_B(:,p),1,pos).*newB;
%             % Ouki is ||Bp-Bq||^2
%             Ouki=(P_R_p-P_R.*newB).^2+(P_G_p-P_R.*newB).^2+(P_B_p-P_R.*newB).^2;
%             % Norm is exp*(1-M)
%             Norm=exp(-Ouki/sigma^2).*P_Map(:,p);
%             sumNorm=sum(sum(Norm));
%             Res=sum(sum(Norm.*P_R))/sumNorm;
%             Ges=sum(sum(Norm.*P_G))/sumNorm;
%             Bes=sum(sum(Norm.*P_B))/sumNorm;
%             % 算SA数，重复的值求平均
%             % 第一二项是根据SA位置和p在SA中的相对位置求得的真实坐标
%             % 第三项是颜色，第四项是预留的多个I值位置
%             Ies(m+rem(p,nsize)-1,n+mod(p,nsize)-1,1)=Res;
%             Ies(m+rem(p,nsize)-1,n+mod(p,nsize)-1,2)=Ges;
%             Ies(m+rem(p,nsize)-1,n+mod(p,nsize)-1,3)=Bes;
%         end
%     end
% end
% e=cputime-t

a=25;
b=25;
Ies=I;
for m=1:M
    for n=1:n
        if Map(m,n)==1
            try
                win1=I(m-a:m+a,n-b:n+b,1).*NewMap(m-a:m+a,n-b:n+b);
                win2=I(m-a:m+a,n-b:n+b,2).*NewMap(m-a:m+a,n-b:n+b);
                win3=I(m-a:m+a,n-b:n+b,3).*NewMap(m-a:m+a,n-b:n+b);
                
                Ies(m,n,1)=sum(sum(win1(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
                Ies(m,n,2)=sum(sum(win2(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
                Ies(m,n,3)=sum(sum(win3(m-a:m+a,n-b:n+b)))/length(find(win1~=0));
            catch
            warning('Close to the edge.');
            end
        end
    end
end

Output(:,:,1)=Ies(:,:,1);
Output(:,:,2)=Ies(:,:,2);
Output(:,:,3)=Ies(:,:,3);

figure
imshow(uint8(Output))
title('Output Image')


