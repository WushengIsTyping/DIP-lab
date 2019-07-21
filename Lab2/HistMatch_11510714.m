function [OutputImage,OutputHist,InputHist]=HistMatch_11510714(InputImage,SpecHist)
L=256;
[M,N]=size(InputImage);

% input hist
InputHist=zeros(1,L);
for m=1:M
    for n=1:N
        InputHist(InputImage(m,n)+1)=InputHist(InputImage(m,n)+1)+1;
    end
end

sk=zeros(1,L);
for j=1:L
    sk(j)=round((L-1)*sum(InputHist(1:j))/M/N);
end

G=zeros(1,L);
A=sum(SpecHist);
for i=1:L
    G(i)=round((L-1)*sum(SpecHist(1:i))/A);
end

OutputImage=zeros(M,N);
for j=1:L
    for m=1:M
        for n=1:N
            if G(j)==sk(InputImage(m,n)+1)
                OutputImage(m,n)=j-1;
                %OutputImage=find(G(x)==sk(InputImage(m,n)+1));
            end
        end
    end
end

OutputHist=zeros(1,L);
for m=1:M
    for n=1:N
        OutputHist(OutputImage(m,n)+1)=OutputHist(OutputImage(m,n)+1)+1;
    end
end


% figure
% OutputImage=uint8(OutputImage);
% imshow(OutputImage)
% figure
% bar(InputHist)
% title('Input Histogram')
% figure
% bar(OutputHist)
% title('Output Histogram')
