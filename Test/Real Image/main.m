addpath('../../Code')

% load image and kernel
for iter1 = 1:4
    for iter2 = 3:6
im_id = [num2str(iter1), '_' , num2str(iter2)]; % change im_id to deblur different images
im_dir = ['BlurryImages/Blurry',im_id,'.png'];
blur = imread(im_dir);
blur = im2double(blur);
Fblur = fft2(blur);
save_kernel_name = ['recover_kernel_',im_id];
save_image_name = ['recover_image_',im_id];

% initialize the kernel guess
init_k = zeros(60); init_k(26:35, 26:35) = rand(10); 
init_k = init_k/sum(sum(init_k));

% kernel estimation
lambda = 0.01; gamma = 40;
tic
[k1, Fk1] = uniform_deblur(blur, lambda, gamma, init_k);
toc

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
end