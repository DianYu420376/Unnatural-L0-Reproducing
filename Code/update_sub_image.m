function out_im = update_sub_image(im, Fy, FK, lambda)
% ---- Description:
% Update the image or subimage while keeping the kernel fixed
% ---- Inputs:
% im: the sharp image predicted at the previous stage
% Fy: the fft of the blurred image
% FK: the fft of the kernel
% lambda: the coefficient for the regularizer
% ---- Output:
% out_im: the predicted image with sharp edges

% create partial_h and partial_v
[m,n,D] = size(Fy);
sizeI2D = [m,n];
fx = [1;-1]; fy = [1,-1];
partial_h = psf2otf(fx,sizeI2D);
partial_v = psf2otf(fy,sizeI2D);
FD = conj(partial_h).*partial_h + conj(partial_v).*(partial_v);
conjFK_FK = conj(FK).*FK;
conjFK_Fy = conj(FK).*Fy; 
epsilon = 0.1;
for t1 = 1:4
    const = lambda/epsilon^2;
    mat2 = conjFK_FK+ const*FD;
    for t2 = 1: 0.1/epsilon
% find h and v
h = [diff(im,1,1); im(1,:,:) - im(end,:,:)];
v = [diff(im,1,2), im(:,1,:) - im(:,end,:)];
if D==1
    t = (h.^2+v.^2)<epsilon^2;
else
    t = sum((h.^2+v.^2),3)<epsilon^2;
    t = repmat(t,[1,1,D]);
end
    h(t)=0; v(t)=0;
Fh = fft2(h);
Fv = fft2(v);
% find image
mat1 = conjFK_Fy + const*(conj(partial_h).* Fh + conj(partial_v).*Fv);
Fim = mat1./mat2;
im = real(ifft2(Fim));
fprintf('.');
    end
    epsilon = epsilon/2;
end
out_im = im;
fprintf('\n')
end