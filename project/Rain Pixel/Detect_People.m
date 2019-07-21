% Detect People 

function [I] = Detect_People(I)
%[FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick a Rainy Image');
%if isequal(FileName,0)||isequal(PathName,0)
%    warndlg('User Pressed Cancel');
%else
%   I = imread([PathName,FileName]);
   
%    I = imresize(I,[256,380]);
  
%end
peopleDetector = vision.PeopleDetector;
%I = imread('Artificial.jpg');
%I = imread('Rainremoved.jpg');
%I = imread('BangaloreRain.jpg');
[bboxes, scores] = step(peopleDetector,I);
scoreInserter = vision.TextInserter('Text','%f','Color',[0 80 255],'LocationSource','Input port','FontSize',16);
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
I = step(shapeInserter,I,int32(bboxes));
I = step(scoreInserter,I,scores,int32(bboxes(:,1:2)));
