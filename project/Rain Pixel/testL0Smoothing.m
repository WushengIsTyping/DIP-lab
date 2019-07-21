
[f p]=uigetfile();
I=imread([p,f])
figure,imshow(I)
S = L0Smoothing(I,0.01);
figure, imshow(S);
