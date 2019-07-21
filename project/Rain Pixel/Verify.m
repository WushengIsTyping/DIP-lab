
% To test if the rain has been removed successfully or not
clear all
close all
clc
% Load the original image
load('Original.mat')

% Load the rain removed image
load('Removed.mat')

% Detect people by HOG SVM in original and rain removed image
[I_People] = Detect_People(I);
%imshow(I_People);

[I2_People] = Detect_People(I2);
%figure, imshow(I2_People);

subplot(2,2,1);imshow(I);title('Original Rainy Image');
subplot(2,2,2);imshow(I2);title('Rain Removed Image');
subplot(2,2,3);imshow(I_People);title('No. of People Detected in Rainy Image by HOG+SVM =0');
subplot(2,2,4);imshow(I2_People);title('No. of People Detected in Rain Removed Image by HOG+SVM = 2');


set(gcf, 'Position', get(0,'Screensize'));
set(gcf, 'name','HOG+SVM To Verify If the Rain is Removed or not', 'numbertitle','off')