function [OutputImage,lap]=test2Func(I,mat)
[M,N]=size(I);
I1=padarray(I,[1,1]);
lap=zeros(M,N);
for i=2:M+1
    for j=2:N+1
        win=double(I1((i-1:i+1),(j-1:j+1)));
        win1=win.*mat;
        lap(i-1,j-1)=sum(sum(win1));
    end
end
%blur=blur+128*ones(M,N);
InputImage=double(I);
OutputImage=InputImage+lap;
OutputImage=uint8(OutputImage);
% figure
% subplot 211
% imshow(OutputImage)
% title('output')
% subplot 212
% imshow(uint8(blur))
% title('Laplacian')