% ÀÔ“›∑… 11510170
function [OutputImage, OutputHist, InputHist] = HistMatch_11510170(InputImage, SpecHist)
mySize = size(InputImage);
InputHist = FindHist_11510170(InputImage);

% Transformation Function T
for idx = 0:255
    T(idx+1) = 255/(mySize(1)*mySize(2)) * sum(InputHist(1,1:(idx+1)));
end
T = round(T);

% Transformation Function G
for idx = 0:255
    G(idx+1) = 255/(sum(SpecHist(1,:))) * sum(SpecHist(1,1:(idx+1)));
end
G = round(G);

% Calculate inverse G(iG)
iG = zeros(1,256)-1; % init iG: -1 means no value of G match this index of iG
iG(1) = 1;
for idx = 0:255
    iG(G(idx+1)+1) = idx; % if G is multi-to-1, iG select the max of the multiple values
end
for idx = 1:255
    if iG(idx+1) == -1
        iG(idx+1) = iG(idx); % convert -1 to its front value
    end
end

% Calculate Matched Image
for xidx = 0:(mySize(1)-1)
    for yidx = 0:(mySize(2)-1)
        OutputImage(xidx+1,yidx+1) = uint8(iG(T(InputImage(xidx+1,yidx+1)+1))+1);
    end
end

% Calculate Matched Histogram
OutputHist = zeros(1,256);
for idx = 0:255
    OutputHist(iG(T(idx+1)+1)+1) = OutputHist(iG(T(idx+1)+1)+1) + InputHist(idx+1);
end
