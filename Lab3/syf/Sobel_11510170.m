%%% Sobelled Image in spacial & frequency domain
%%% ÀÔ“›∑… 11510170
clear all;clc;
%% Time Domain
f = double(imread('Q3_1.tif'));
[M,N] = size(f);
P = M+3-1;
Q = N+3-1;
EpdImage = [zeros(1,N+2); ...
    zeros(M,1), f, zeros(M,1); ...
    zeros(1,N+2)];
h = [-1,0,1; -2,0,2; -1,0,1];
g1 = zeros(M,N);
for xidx = 0:(M-1) 
	for yidx = 0:(N-1)
        tmp = EpdImage(xidx+1:xidx+3,yidx+1:yidx+3).*h;
        g1(xidx+1,yidx+1) = sum(sum(tmp));
    end
end
%% Frequency Domain
Minus1Mat = repmat([1,-1;-1,1],P/2,Q/2);
f_p = [f, zeros(M,2); zeros(2,Q)];
F = fft2(f_p.*Minus1Mat);
% F = fftshift(fft2(f_p));

h_p = [zeros(300,Q); ...
	zeros(3,300),h,zeros(3,299); ...
    zeros(299,Q)];
H = imag(fft2(h_p.*Minus1Mat)).*Minus1Mat;
% H = imag(fftshift(fft2(h_p)));

G2 = H.*F;
g2_p = imag(ifft2(G2)).*Minus1Mat;
% g2_p = ifftshift(abs(ifft2(G2)));
g2 = g2_p(1:M,1:N);

%% Plot
figure(1)
subplot 352
imshow(uint8(f))
title('f')
subplot 353
imshow(uint8(10*log2(1+abs(F))))
title('F')
subplot 354
imshow(uint8((H+8)*255/16))
title('H')
subplot 357
imshow(uint8(abs(g1)))
title('g1(spac. domain result)')
subplot 359
imshow(uint8(abs(g2)))
title('g2(freq. domain result)')