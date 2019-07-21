% combination of salt-and-pepper and Gaussian
I=imread('Q4_1_4.tiff');
InputImage=double(I);
[M,N]=size(InputImage);
fp=padarray(InputImage,[round(M/2),round(N/2)]); % padded image

cent=ones(size(fp));
for i=1:M*2
    for j=1:N*2
        if rem(i+j,2)==1
            cent(i,j)=-1;
        end
    end
end
F=fft2(fp.*cent);

% eliminate salt-and-pepper first, then gaussian
win=[5,5];
a=(win(1)-1)/2;
b=(win(2)-1)/2;
fp=padarray(InputImage,[a,b]);

f1=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        win=fp((i-a:i+a),(j-b:j+b));
        f1(i,j)=median(median(win));
    end
end

% midpoint filter is the best for distributed noise
win2=[3,3];
a=(win2(1)-1)/2;
b=(win2(2)-1)/2;
fp2=padarray(f1,[a,b]);
f2=zeros(M,N);
for i=a+1:M+a
    for j=b+1:N+b
        win=fp2((i-a:i+a),(j-b:j+b));
        f2(i,j)=1/2*(max(max(win))+min(min(win)));
    end
end
OutputImage=uint8(f2);

% % Alpha-trimmed mean filter
% win=[5,5];
% a=(win(1)-1)/2;
% b=(win(2)-1)/2;
% fp=padarray(InputImage,[a,b]);
% d=10;
% 
% f=zeros(M,N);
% for i=a+1:M+a
%     for j=b+1:N+b
%         window=fp((i-a:i+a),(j-b:j+b));
%         win1=reshape(window,[win(1),win(2)]);
%         Rank=sort(window);
%         f(i,j)=(1/(win(1)*win(2)-d))*(sum(sum(window))-sum(Rank(1:d/2))-sum(Rank(end-d/2+1:end)));
%     end
% end
% OutputImage=uint8(f);

figure
subplot 221
imshow(uint8(I))
title('Input Image')
subplot 222
imshow(uint8(10*log2(1+abs(F))))
title('Frequency Domain')
subplot 223
histogram(I)
title('Input Image Histogram')
subplot 224
imshow(OutputImage(3:end,3:end))
title('Output Image')