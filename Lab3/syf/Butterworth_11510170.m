%%% Butterworth BR & BP
%%% ÀÔ“›∑… 11510170
clear all;clc;
InputImage = double(imread('Q3_3.tif'));
D_0 = 15;
n = 4; % Butterworth filter order
u_k = [55,55,-55,-55];
v_k = [80,160,80,160];
%% Calculate F
[M,N] = size(InputImage);
P = 2*M; Q = 2*N;
f_p = zeros(P,Q); 
f_p(1:M,1:N) = InputImage; % Padded Image
Minus1Mat = repmat([1,-1;-1,1],P/2,Q/2);
F = fft2(f_p.*Minus1Mat);
%% Calculate D_k & D_-k
D_1 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) - u_k(1)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) - v_k(1)*ones(P,Q)).^2);
D__1 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) + u_k(1)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) + v_k(1)*ones(P,Q)).^2);
D_2 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) - u_k(2)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) - v_k(2)*ones(P,Q)).^2);
D__2 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) + u_k(2)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) + v_k(2)*ones(P,Q)).^2);
D_3 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) - u_k(3)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) - v_k(3)*ones(P,Q)).^2);
D__3 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) + u_k(3)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) + v_k(3)*ones(P,Q)).^2);
D_4 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) - u_k(4)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) - v_k(4)*ones(P,Q)).^2);
D__4 = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q) + u_k(4)*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q) + v_k(4)*ones(P,Q)).^2);
%% Calculate H_NR
H_NR = ones(P,Q);
H_1 = 1./(1+(D_0*ones(P,Q)./D_1).^(2*n));
H__1 = 1./(1+(D_0*ones(P,Q)./D__1).^(2*n));
H_2 = 1./(1+(D_0*ones(P,Q)./D_2).^(2*n));
H__2 = 1./(1+(D_0*ones(P,Q)./D__2).^(2*n));
H_3 = 1./(1+(D_0*ones(P,Q)./D_3).^(2*n));
H__3 = 1./(1+(D_0*ones(P,Q)./D__3).^(2*n));
H_4 = 1./(1+(D_0*ones(P,Q)./D_4).^(2*n));
H__4 = 1./(1+(D_0*ones(P,Q)./D__4).^(2*n));
H_NR = H_NR .* H_1 .* H__1 .* H_2 .* H__2 .* H_3 .* H__3 .* H_4 .* H__4;
%% Calculate G
G = H_NR.*F;
g_p = abs(ifft2(G));
OutputImage = g_p(1:M,1:N);
%% Plot
figure(1)
subplot 252
imshow(uint8(InputImage))
title('Original Image')
subplot 253
imshow(uint8(10*log2(1+abs(F))))
title('F')
subplot 254
imshow(uint8(10*log2(1+abs(H_NR))))
title('H_N_R')
subplot 255
imshow(uint8(10*log2(1+abs(G))))
title('G')
subplot 256
imshow(uint8(OutputImage))
title('OutputImage')
