%%% Gaussian LPF & HPF
%%% ÀÔ“›∑… 11510170
clear all;clc;
InputImage = double(imread('Q3_2.tif'));
D_0 = [30,60,160];
OutputImage_LPF1 = Gaussian_11510170('LPF',InputImage,D_0(1));
OutputImage_LPF2 = Gaussian_11510170('LPF',InputImage,D_0(2));
OutputImage_LPF3 = Gaussian_11510170('LPF',InputImage,D_0(3));
OutputImage_HPF1 = Gaussian_11510170('HPF',InputImage,D_0(1));
OutputImage_HPF2 = Gaussian_11510170('HPF',InputImage,D_0(2));
OutputImage_HPF3 = Gaussian_11510170('HPF',InputImage,D_0(3));
%% Plot
figure(1)
subplot 241
imshow(uint8(InputImage))
title('Original Image')
subplot 242
imshow(uint8(abs(OutputImage_LPF1)))
title(['After LPF(D_0=',int2str(D_0(1)),')'])
subplot 243
imshow(uint8(abs(OutputImage_LPF2)))
title(['After LPF(D_0=',int2str(D_0(2)),')'])
subplot 244
imshow(uint8(abs(OutputImage_LPF3)))
title(['After LPF(D_0=',int2str(D_0(3)),')'])
subplot 246
imshow(uint8(abs(OutputImage_HPF1)))
title(['After HPF(D_0=',int2str(D_0(1)),')'])
subplot 247
imshow(uint8(abs(OutputImage_HPF2)))
title(['After HPF(D_0=',int2str(D_0(2)),')'])
subplot 248
imshow(uint8(abs(OutputImage_HPF3)))
title(['After HPF(D_0=',int2str(D_0(3)),')'])