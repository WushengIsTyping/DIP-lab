%%% Gaussian LPF & HPF
%%% ÀÔ“›∑… 11510170
function OutputImage = Gaussian_11510170(type,InputImage,D_0)
%% Calculate F
[M,N] = size(InputImage);
P = 2*M; Q = 2*N;
f_p = zeros(P,Q); 
f_p(1:M,1:N) = InputImage; % Padded Image
Minus1Mat = repmat([1,-1;-1,1],P/2,Q/2);
F = fft2(f_p.*Minus1Mat);
%% Calculate D
D = sqrt((repmat([1:Q],P,1) - Q/2*ones(P,Q)).^2 + ...
    (repmat([1:P]',1,Q) - P/2*ones(P,Q)).^2);
%% Calculate H
if type == 'LPF'
    H = exp(-D.^2/(2*D_0^2));
else % type == 'HPF'
    H = 1 - exp(-D.^2/(2*D_0^2)); 
end
%% Calculate G
G = H.*F;
g_p = real(ifft2(G)).*Minus1Mat;
OutputImage = g_p(1:M,1:N);
