I=imread('D:\MATLAB\DIP\rice.tif');
dim=[round(256*1.8) round(256*1.8)];
output=InterpolationBilinear(I,dim);
figure
output=uint8(output);
imshow(output)
% figure
% output=uint8(output);
% imshow(output)
% figure
% output=uint8(output);
% imshow(output)
% figure
% output=uint8(output);
% imshow(output)
