[f,p]=uigetfile();
I=imread([p,f]);
I=imresize(I, [512 512]);
figure,imshow(I)
title('The selected input image');
way;