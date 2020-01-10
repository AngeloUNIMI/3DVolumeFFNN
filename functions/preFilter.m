function [I1r, I1g, I1b, I1gray, I2r, I2g, I2b, I2gray] = preFilter(imA, imB)


hs = fspecial('sobel');
%I1 = normalizzaMat(imA);
%I2 = normalizzaMat(imB);
I1 = imA;
I2 = imB;
I1gray = rgb2gray(I1);
I2gray = rgb2gray(I2);

I1 = I1 + imfilter(I1,hs);
I1gray = I1gray + imfilter(I1gray,hs);
I2 = I2 + imfilter(I2,hs);
I2gray = I2gray + imfilter(I2gray,hs);

I1r = I1(:,:,1);
I1g = I1(:,:,2);
I1b = I1(:,:,3);


I2r = I2(:,:,1);
I2g = I2(:,:,2);
I2b = I2(:,:,3);