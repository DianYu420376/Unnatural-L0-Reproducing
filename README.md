# Unnatural-L0-Reproducing

This repository is attempting to implement the algorithm described in 'Unnatural L0 Sparse Representation for Natural Image Deblurring'(Xu et al. 2013).

The code folder contains the main code of the implementation. The test folder contains some simple testing examples. Run 'test/.../main.m' to see the result of the implementation.

Note: Currently the examples in 'test/toy example' folder is just generated blur, i.e, use cyclic convolution on a real sharp image with a blurring kernel, the kernel is downloaded for this following website: http://webdav.is.mpg.de/pixel/benchmark4camerashake/#Top. The result for toy example with small or medium sized blur is pretty good, yet for real image in 'test/real image', the result is still not very satisfying, the blurry images still come from the above website.

Some problems that need to be solved:
1. Cannot handle large blur right now.
2. Still cannot find a good way to handle the boundary for real images.
