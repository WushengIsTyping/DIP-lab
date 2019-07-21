%% To find only rain
function [No_Of_RainPixels,OnlyRainImage] = find_rain(I)
if ndims(I) == 3
   I2=rgb2gray(I);
else
   I2 = I;
end

BW2 = bwmorph(I2,'remove');
%figure,imshow(BW2);
BW3 = bwmorph(I2,'skel',Inf);
%figure,imshow(BW3);

SE = strel('arbitrary',eye(5));

BW2 = imerode(I2,SE);
%figure,imshow(BW2)
BW3 = imdilate(BW2,SE);
%figure,imshow(BW3)
closeBW = imclose(BW3,SE);
%figure, imshow(closeBW);
hy = fspecial('sobel');

hx = hy';
Iy = imfilter(double(I), hy, 'replicate');
Ix = imfilter(double(I), hx, 'replicate');
gradmag = sqrt(Ix.^2 + Iy.^2);
Iobrd = imdilate(BW2, SE );
Iobrcbr = imreconstruct(imcomplement(Iobrd), imcomplement(closeBW));
Iobrcbr = imcomplement(Iobrcbr);
%figure, imshow(Iobrcbr);
OnlyRainImage = imregionalmax(Iobrcbr);
%figure, imshow(OnlyRainImage);title('Only Rain');
 % Perform connected component analysis
 cc = bwconncomp(OnlyRainImage,8);
 No_Of_RainPixels = cc.NumObjects;