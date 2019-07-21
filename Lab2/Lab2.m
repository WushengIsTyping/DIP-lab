% Lab2 test 
% question 1 using Q2_1_1
% I=imread('D:\MATLAB\DIP\Q2_1_1.tif');
%[OutputImage,InputHist,OutputHist]=HistEqu_11510714(I);

% qustion 1 using Q2_1_2
% I=imread('D:\MATLAB\DIP\Q2_1_2.tif');
% [OutputImage,InputHist,OutputHist]=HistEqu_11510714(I);

% qustion 2
I=imread('D:\MATLAB\DIP\Q2_2.tif');
SpecHist=10000*[100,100,100,linspace(128,64,125)/128,zeros(1,32),ones(1,64+32)];
[OutputImage,OutputHist,InputHist]=HistMatch_11510714(I,SpecHist);

%question 3
I=imread('D:\MATLAB\DIP\Q2_3.tif');
mSize=[9,9];
[OutputImage, OutputHist, InputHist] = LocalHistEqu_11510714(I, mSize);

% question 4
I=imread('D:\MATLAB\DIP\Q2_4.tif');
nsize=[5,5];
[OutputImage]=ReduceSAP_11510714(I,nsize);
