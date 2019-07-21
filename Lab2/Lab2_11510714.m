I=imread('D:\MATLAB\DIP\Q2_1_1.tif');
[OutputImage,InputHist,OutputHist]=HistEqu_11510714(I);

% r is innput intensity value
% n is number of pixels in intensity r
% size M*N
% histogram h(r)=n

% 0-(L-1) the intensity range of new image
% r input intensity, s=T(r) new intensity
% T function presenting the transforming relationship

% p(r) and p(s) probability density 
% now we have the p(r) and p(s) and r and nr
% want to get s,find T function

% on lecture 2 p33 the function shows the relationship
% input is nr



