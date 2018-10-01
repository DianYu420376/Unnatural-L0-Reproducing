function out_im = deconv(im, Fy, FK, lambda)
% ---- Description:
% Non-blind deconvolution algorithm. This implementation is the L1
% regularization version. (you only need to change a few line of the L0 smoothing to get this algorithm)
% Generally the L2/3 version is said to have the best result,
% but I am too lazy to write it out...
% ---- Inputs:
% im: the sharp image predicted at the previous stage
% Fy: the fft of the blurred image
% FK: the fft of the kernel
% lambda: the coefficient for the regularizer
% ---- Output:
% out_im: the predicted image with sharp edges

% create partial_h and partial_v
[m,n,~] = size(Fy);
sizeI2D = [m,n];
fx = [1;-1]; fy = [1,-1];
partial_h = psf2otf(fx,sizeI2D);
partial_v = psf2otf(fy,sizeI2D);
FD = conj(partial_h).*partial_h + conj(partial_v).*(partial_v);

epsilon = 1;
conjFK_FK = conj(FK).*FK;
conjFK_Fy = conj(FK).*Fy;
fprintf('deconvolving \n')
for t1 = 1:4
    const = lambda/epsilon^2;
    mat2 = conjFK_FK+ const*FD;
    for t2 = 1: 2/epsilon
% find h and v
h = [diff(im,1,1); im(1,:,:) - im(end,:,:)];
v = [diff(im,1,2), im(:,1,:) - im(:,end,:)];
beta = epsilon^2;
h(abs(h) <= lambda/beta) = 0;
h(h > lambda/beta) = h(h > lambda/beta) - lambda/beta;
h(h < lambda/beta) = h(h < lambda/beta) + lambda/beta;
v(abs(v) <= lambda/beta) = 0;
v(v > lambda/beta) = v(v > lambda/beta) - lambda/beta;
v(v < lambda/beta) = v(v < lambda/beta) + lambda/beta; 
Fh = fft2(h);
Fv = fft2(v);
% find image
mat1 = conjFK_Fy + const*(conj(partial_h).* Fh + conj(partial_v).*Fv);
Fim = mat1./mat2;
im = real(ifft2(Fim));
fprintf('.')
    end
    epsilon = epsilon/2;
fprintf('\n')
end
out_im = im;
end