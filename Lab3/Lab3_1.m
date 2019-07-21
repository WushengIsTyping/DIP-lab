I=imread('Q3_1.tif');
OutputImage=Sobel_11510714(I);

I=imread('Q3_2.tif');
D0=30;
glpf(I,D0);
[OutputImageL,OutputImageH]=Gaussian_11510714(I,D0);

I=imread('Q3_3.tif');
D0=10;
%Q32_11410292(I,D0);
OutputImage=Butterworth_11510714(I,D0);
