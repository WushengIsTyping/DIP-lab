% Detect People 


[FileName,PathName] = uigetfile('*.jpg;*.png;*.bmp','Pick a Rainy Image');
if isequal(FileName,0)||isequal(PathName,0)
    warndlg('User Pressed Cancel');
else
   I2 = imread([PathName,FileName]);
   
   I2 = imresize(I2,[256,380]);
  
end
peopleDetector = vision.PeopleDetector;
%I = imread('Artificial.jpg');
%I = imread('Rainremoved.jpg');
%I = imread('BangaloreRain.jpg');
[bboxes, scores] = step(peopleDetector,I2);
scoreInserter = vision.TextInserter('Text','%f','Color',[0 80 255],'LocationSource','Input port','FontSize',16);
shapeInserter = vision.ShapeInserter('BorderColor','Custom','CustomBorderColor',[255 255 0]);
I2 = step(shapeInserter,I2,int32(bboxes));
I2 = step(scoreInserter,I2,scores,int32(bboxes(:,1:2)));
imshow(I2);