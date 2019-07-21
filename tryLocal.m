A=imread('Q2_3.tif');
figure,imshow(A);
Img=A;
     
  
%WINDOW SIZE
M=15;
N=15;

mid_val=round((M*N)/2);

%FIND THE NUMBER OF ROWS AND COLUMNS TO BE PADDED WITH ZERO
in=0;
for i=1:M
    for j=1:N
        in=in+1;
        if(in==mid_val)
            PadM=i-1;
            PadN=j-1;
            break;
        end
    end
end
%PADDING THE IMAGE WITH ZERO ON ALL SIDES
B=padarray(A,[PadM,PadN]);
% 左右各加了19，上下各加了4

for i= 1:size(B,1)-((PadM*2)+1)
    % M-(4*2+1)
    for j=1:size(B,2)-((PadN*2)+1)
        cdf=zeros(256,1);
        inc=1;
        for x=1:M
            for y=1:N
  %FIND THE MIDDLE ELEMENT IN THE WINDOW          
                if(inc==mid_val)
                    ele=B(i+x-1,j+y-1)+1;
                end
                    pos=B(i+x-1,j+y-1)+1;
                    cdf(pos)=cdf(pos)+1;
                   inc=inc+1;
            end
        end
                      
        %COMPUTE THE CDF FOR THE VALUES IN THE WINDOW
        for l=2:256
            cdf(l)=cdf(l)+cdf(l-1);
        end
            Img(i,j)=round(cdf(ele)/(M*N)*255);
     end
end
figure,imshow(Img);
figure,
subplot(2,1,1);title('Before Local Histogram Equalization'); imhist(A);
subplot(2,1,2);title('After Local Histogram Equalization'); imhist(Img);

% B=InputImage; 
% for i=1:M-m1+1
%     for j=1:N-m2+1
%         win=InputImage((i:i+m1-1),(j:j+m2-1));
%         pdf=zeros(1,256);
%         cdf=zeros(1,256);
%         for m=1:m1
%             for n=1:m2
%                 pdf(win(m,n)+1)=pdf(win(m,n)+1)+1;
%             end
%         end
%         for k=1:256
%             cdf(k)=round(255*sum(pdf(1:k))/m1/m2);
%         end
%         B(i+(m1+1)/2,j+(m2+1)/2)=cdf(win((m1+1)/2,(m2+1)/2)+1);
% %         for a=i:m1+i-1
% %             for b=j:m2+j-1
% %                 B(a,b)=cdf(win(a,b));
% %             end
% %         end
%     end
% end