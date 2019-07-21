S = L0Smoothing(I,0.01);
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
%figure, imshowpair(I,S,'montage');
title('Original & Rain Pixel Removal Image')
way;
