addpath('../../Code')

% load image and kernel
im = imread('image/sharp image.jpg');
im = im2double(im);
num = '1';  % change the number of the kernel to generate different blur
ker_dir = ['image/kernel', num,'.png'];
k = imread(ker_dir);
k = im2double(k); k = k(:,:,1);k = k/sum(sum(k));
save_kernel_name = ['recover_kernel_',num];
save_image_name = ['recover_image_',num];

% generate the blur image
[m,n,D] = size(im); sizeI2D = [m,n];
Fim = fft2(im); Fk = psf2otf(k, sizeI2D); Fblur = Fim.*Fk;
blur = real(ifft2(Fblur));

% initialize the kernel guess
init_k = zeros(60); init_k(26:35, 26:35) = rand(10); 
init_k = init_k/sum(sum(init_k));

% kernel estimation
lambda = 0.01; gamma = 40;
tic
[k1, Fk1] = uniform_deblur(blur, lambda, gamma, init_k);
toc
figure; 
subplot(1,2,1)
imshow(40*k)
subplot(1,2,2)
imshow(40*k1/sum(sum(k1)));

% non-blind deconvolution
tic
out_im = deconv(blur, Fblur, Fk1, 0.0005);
toc
figure;
subplot(1,2,1)
imshow(blur)
subplot(1,2,2)
imshow(out_im*sum(sum(k1)))

figure;
saveas(imshow(40*k1/sum(sum(k1))), ['results/',save_kernel_name,'.png'])
figure;
saveas(imshow(out_im*sum(sum(k1))), ['results/',save_image_name,'.jpg'])
end
