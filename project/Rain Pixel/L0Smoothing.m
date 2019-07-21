
function S = L0Smoothing(Im, lambda, kappa)
%L0Smooth - Image Smoothing via L0 Gradient Minimization
%   S = L0Smooth(Im, lambda, kappa) performs L0 graidient smoothing of input
%   image Im, with smoothness weight lambda and rate kappa.
%
%   Paras: 
%   @Im    : Input UINT8 image, both grayscale and color images are acceptable.
%   @lambda: Smoothing parameter controlling the degree of smooth. (See [1]) 
%            Typically it is within the range [1e-3, 1e-1], 2e-2 by default.
%   @kappa : Parameter that controls the rate. (See [1])
%            Small kappa results in more iteratioins and with sharper edges.   
%            We select kappa in (1, 2].    
%            kappa = 2 is suggested for natural images.  
%
%   Example
%   ==========
%   Im  = imread('pflower.jpg');
%   S  = L0Smooth(Im); % Default Parameters (lambda = 2e-2, kappa = 2)
%   figure, imshow(Im), figure, imshow(S);


if ~exist('kappa','var')
% if kappa is mentioned take that value, else take the default value of 2
    kappa = 2.0;
end
if ~exist('lambda','var')
% if lambda is mentioned take that value, else take the default value of
% 2e-2
    lambda = 2e-2;
end
% Convert image to double
S = im2double(Im);
% Set betamax to a constant value
betamax = 1e5;
% Create x and y vectors as below
fx = [1, -1];
fy = [1; -1];
% Extract no. of rows N, no. of columns M and no. of color channels D from
% the image
[N,M,D] = size(Im);
% Consider only no. of rows and no of columns
sizeI2D = [N,M];
% Convert point-spread function to optical transfer function along x and y
% axes
otfFx = psf2otf(fx,sizeI2D);
otfFy = psf2otf(fy,sizeI2D);
% Evaluate Fast Fourier Transform of the image Normin1
Normin1 = fft2(S);
% Evaluate denormalized minimum from the x and y optical transfer functions
Denormin2 = abs(otfFx).^2 + abs(otfFy ).^2;
% D >1 means a color image
if D>1
% convert Denormin2 to color image
    Denormin2 = repmat(Denormin2,[1,1,D]);
end
beta = 2*lambda;

itr = betamax;
hWaitBar = waitbar(0,'Removing Rain....Please Wait!!!...');

while beta < betamax
    waitbar(beta/betamax);
  
    Denormin   = 1 + beta*Denormin2;
    % h-v subproblem
    h = [diff(S,1,2), S(:,1,:) - S(:,end,:)];
    v = [diff(S,1,1); S(1,:,:) - S(end,:,:)];
    % if the image is Grayscale (i.e D = 1)
    if D==1
    % t is threshold value
        t = (h.^2+v.^2)<lambda/beta;
    else
    % if the image is color (ie D>1) 
        t = sum((h.^2+v.^2),3)<lambda/beta;
    % convert threshold t to color threshold using repmat
        t = repmat(t,[1,1,D]);
    end
    h(t)=0; v(t)=0;
    % S subproblem
    Normin2 = [h(:,end,:) - h(:, 1,:), -diff(h,1,2)];
    Normin2 = Normin2 + [v(end,:,:) - v(1, :,:); -diff(v,1,1)];
    FS = (Normin1 + beta*fft2(Normin2))./Denormin;
    % Extract only the real part from the inverse fast fourier transform
    S = real(ifft2(FS));
    beta = beta*kappa;
    fprintf('.');
 
end
delete(hWaitBar);
fprintf('\n');

end

