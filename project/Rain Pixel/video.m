clc;    % Clear the command window.
%close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.
fontSize = 14;

if(~isdeployed)
	cd(fileparts(which(mfilename)));
end
%vid=mmreader('auto.mp4');
vid=VideoReader('blackcarvideo.mp4');
  
numFrames = vid.NumberOfFrames;
n=numFrames;
pickind='jpg';
for i = 1:2:n
frames = read(vid,i);
strtemp=strcat('C:\Program Files\MATLAB\R2013a\Rain Pixel\blackcarframes\',int2str(i),'.',pickind);  
imwrite(frames ,strtemp)
  
%imwrite(frames,['Image' int2str(i), '.jpg']);
 im(i)=image(frames);
end
  
%[f,p]=uigetfile()
%I=imread([p,f])
way;