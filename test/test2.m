I=imread('T1_1.tif');
mat1=[-1 -1 -1;-1 8 1;-1 -1 -1];
mat2=[-1 -2 -1;0 0 0;1 2 1];
mat3=[-1 0 1;-2 0 2;-1 0 1];
[OutputImage1,blur1]=test2Func(I,mat1);
[OutputImage2,blur2]=test2Func(I,mat2);
[OutputImage3,blur3]=test2Func(I,mat3);
figure
subplot 231
imshow(OutputImage1)
title('output 1')
subplot 234
imshow(uint8(blur1))
title('Laplacian 1')
subplot 232
imshow(OutputImage2)
title('output 2')
subplot 235
imshow(uint8(blur2))
title('Laplacian 2')
subplot 233
imshow(OutputImage3)
title('output 3')
subplot 236
imshow(uint8(blur3))
title('Laplacian 3')





