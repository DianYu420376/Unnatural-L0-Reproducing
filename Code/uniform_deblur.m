function [k, FK] = uniform_deblur(y, lambda,gamma, init_k)
% ---- Description:
% The implementation of uniform deblur in the unnatural L0 paper
% ---- Inputs:
% y: The blur image
% lambda & gamma: The regularization coefficients
% init_k: The initial kernel guess for the first iteration

[m,n,~] = size(y);
sizeI2D = [m,n];
Fy = fft2(y);
k = init_k;
FK = psf2otf(k, sizeI2D);
im = y;
fprintf('estimating kernel \n')
for i = 1:5
im = update_sub_image(im, Fy, FK, lambda);
fft_im = fft2(im);
[k,FK] = update_kernel_uniform(Fy, fft_im,  gamma, size(k));
end
end