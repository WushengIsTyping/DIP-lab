clc;    % Clear the command window.
%close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 14;

if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
% vid=mmreader('Heavy Rain - 1 minute project-HD.mp4');
%vid=VideoReader('Heavy Rain - 1 minute project-SD.mp4');
  
 %numFrames = vid.NumberOfFrames;
 %n=numFrames;
 %pickind='jpg';
 %for i = 1:2:n
 %frames = read(vid,i);
 %strtemp=strcat('D:\frames\',int2str(i),'.',pickind);  
%imwrite(frames ,strtemp)
  
 %imwrite(frames,['Image' int2str(i), '.jpg']);
% im(i)=image(frames);
% end
  
[f,p]=uigetfile()
I=imread([p,f]);
I = imresize(I,[256,380]);
Img = imadjust(I,stretchlim(I));
%% To find only rain
I2=rgb2gray(I);
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
fgm = imregionalmax(Iobrcbr);
figure, imshow(fgm);title('Only Rain');

%%
I2 = I;
I2(fgm) = 200;
figure, imshow(I2)
se2 = strel(ones(5,5));
fgm2 = imclose(fgm, se2);
fgm3 = imerode(fgm2, se2);

fgm4 = bwareaopen(fgm3, 20);
I3 = I;
I3(fgm4) = 200;
figure, imshow(I3)

cform = makecform('srgb2lab');
lab_he = applycform(I,cform);
ab = double(lab_he(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels,[])

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = I;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

imshow(segmented_images{1});
figure,imshow(segmented_images{2});
figure,imshow(segmented_images{3});

 inImg = im2double(rgb2gray(I));
inImg = imresize(inImg, 64/size(inImg, 2));

%% Spectral Residual
myFFT = fft2(inImg); 
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate'); 
saliencyMap1 = abs(ifft2(exp(mySpectralResidual + i*myPhase))).^2;

%% After Effect
saliencyMap = mat2gray(imfilter(saliencyMap1, fspecial('gaussian', [10, 10], 2.5)));
%figure,imshow(saliencyMap);
%title('salince detection')


%%

dim = size(I);
width = dim(2);height = dim(1);
md = min(width, height);%minimum dimension
 cform = makecform('srgb2lab', 'AdaptedWhitePoint', whitepoint('d65'))
lab = applycform(I,cform);
l = double(lab(:,:,1));
a = double(lab(:,:,2));
b = double(lab(:,:,3));
%If you have your own RGB2Lab function...
%[l a b] = RGB2Lab(gfrgb(:,:,1),gfrgb(:,:,2), gfrgb(:,:,3));
%---------------------------------------------------------
%Saliency map computation
%---------------------------------------------------------
sm = zeros(height, width);
off1 = int32(md/2); off2 = int32(md/4); off3 = int32(md/8);
for j = 1:height
    y11 = max(1,j-off1); y12 = min(j+off1,height);
    y21 = max(1,j-off2); y22 = min(j+off2,height);
    y31 = max(1,j-off3); y32 = min(j+off3,height);
    for k = 1:width
        x11 = max(1,k-off1); x12 = min(k+off1,width);
        x21 = max(1,k-off2); x22 = min(k+off2,width);
        x31 = max(1,k-off3); x32 = min(k+off3,width);
        lm1 = mean2(l(y11:y12,x11:x12));am1 = mean2(a(y11:y12,x11:x12));bm1 = mean2(b(y11:y12,x11:x12));
        lm2 = mean2(l(y21:y22,x21:x22));am2 = mean2(a(y21:y22,x21:x22));bm2 = mean2(b(y21:y22,x21:x22));
        lm3 = mean2(l(y31:y32,x31:x32));am3 = mean2(a(y31:y32,x31:x32));bm3 = mean2(b(y31:y32,x31:x32));
        %---------------------------------------------------------
        % Compute conspicuity values and add to get saliency value.
        %---------------------------------------------------------
        cv1 = (l(j,k)-lm1).^2 + (a(j,k)-am1).^2 + (b(j,k)-bm1).^2;
        cv2 = (l(j,k)-lm2).^2 + (a(j,k)-am2).^2 + (b(j,k)-bm2).^2;
        cv3 = (l(j,k)-lm3).^2 + (a(j,k)-am3).^2 + (b(j,k)-bm3).^2;
        sm(j,k) = cv1 + cv2 + cv3;
    end
end

%imshow(sm,[]);
%S = L0Smoothing(Img ,0.01);
S = L0Smoothing(Img);
%S = L0Smoothing(K);
S = imadjust(S,stretchlim(S));
%%
% Try to enhance the quality of the images

srgb2lab = makecform('srgb2lab');
lab2srgb = makecform('lab2srgb');

shadow_lab = applycform(S, srgb2lab); % Convert to L*a*b*
% The values of luminosity can span a range from 0 to 100; scale them
% to [0 1] range (appropriate for MATLAB(R) intensity images of class double) 
% before applying any of the three contrast enhancement techniques
max_luminosity = 100;
L = shadow_lab(:,:,1)/max_luminosity;

% Replace the luminosity layer with the processed data and then convert
% the image back to the RGB colorspace
shadow_imadjust = shadow_lab;
% Alter Intensity
shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
% Convert the image back to RGB
shadow_imadjust = applycform(shadow_imadjust, lab2srgb);
% Display as a pair, i.e the original and the enhanced rain pixel removal
% images
figure, imshowpair(I,shadow_imadjust,'montage');
imwrite(shadow_imadjust,'RainRemoved.jpg');
%figure, imshowpair(I,S,'montage');
title('Original & Rain Pixel Removal Image');
%[No_Of_RainPixels OnlyRain] = find_rain(shadow_imadjust);
% Evaluate Peak Signal to Noise Ratio (PSNR) after contrast enhancement
im1 = double(I);
im2 = double(shadow_imadjust);
mse = sum((im1(:)-im2(:)).^2)/prod(size(im1));
psnr1 = 10*log10(255*255/mse)
%figure,bar(psnr,.2);title('Peak Signal to Noise Ratio');

% Evaluate Peak Signal to Noise Ratio after Smoothing operation
im3 = double(S);
mse2 = sum((im1(:)-im3(:)).^2)/prod(size(im1));
psnr2 = 10*log10(255*255/mse2)
psnr = [psnr2,psnr1];
figure,bar(psnr,0.25);title('PSNR values before & after contrast enhancement');
[No_Of_RainPixels1 OnlyRainImage1] = find_rain(I);
[No_Of_RainPixels2 OnlyRainImage2] = find_rain(shadow_imadjust);
figure, imshow(OnlyRainImage2);
Percent_RainRemoval = (No_Of_RainPixels2)/(No_Of_RainPixels1)
close all