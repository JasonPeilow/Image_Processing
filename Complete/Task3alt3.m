% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se = strel('disk',2);

Img = imread('Starfish.jpg');
subplot(2,3,1), imshow(Img);
title('Step-1: Default Image');

grayImg = rgb2gray(Img);
subplot(2,3,2), imshow(grayImg);
title('Step-2: Convert to grayscale and reduce noise');

En = entropyfilt(grayImg);
%Rescaled into zeros and ones
reEn = rescale(En);
subplot(2,3,3), imshow(reEn );
title('Step-3: Layered Mask');

BW = imbinarize(reEn, .8);
BWao = bwareafilt(BW,[500 2000]);
BWao = imerode(BWao,se);
%9*9 neighbourhood
nhood = true(9);
%BWao = imerode(BWao,se);
BWao = imclose(BWao,nhood);
mask = imfill(BWao,'holes');

subplot(2,3,4), imshow(mask);
title('Step-3: Layered Mask');

texture1 = grayImg;
texture1(mask) = 255;
texture2 = grayImg;
texture2(~mask) = 255;

subplot(2,3,5), imshow(texture1);
title('Step-7: Where are the starfish...?');

subplot(2,3,6), imshow(texture2);
title('Step-8: ...There are the starfish!');

%{
boundary = bwperim(mask2);
segmentResults = redNoise;
segmentResults(boundary) = 0;
subplot(2,3,6), imshow(segmentResults);
title('Step-9: Final Output?');
%}