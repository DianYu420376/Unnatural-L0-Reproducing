function [k, FK] = update_kernel_uniform(fft_y, fft_im,  gamma, size_k)
% ---- Description:
% Updating the kernel while keeping the image fixed. Note that this
% algorithm is only applicable to uniform blur
% ---- Inputs:
% fft_y: the fft of the blurred image
% fft_im: the fft of the predicted sharp image
% gamma: the coefficient of the regularization term on k
% size_k: The size of the blur kernel
% ---- Output:
% k: the predicted blur kernel

mat1 = conj(fft_im).*fft_y;
mat2 = (conj(fft_im).*fft_im);
FK = sum(mat1, 3)./(sum(mat2, 3) + gamma);
k = otf2psf(FK, size_k);
FK = psf2otf(k, [size(fft_y,1), size(fft_y,2)]);
end