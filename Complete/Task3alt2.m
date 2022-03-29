% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se = strel('disk',3);

Img = imread('Starfish.jpg');
subplot(3,3,1), imshow(Img);
title('Step-1: Default Image');

grayImg = rgb2gray(Img);
redNoise = medfilt2(grayImg);
subplot(3,3,2), imshow(redNoise);
title('Step-2: Convert to Grayscale');

%Reduce the noise in the image

adjContr = imadjust(redNoise,[0.7 1.0],[]);
%{ 
-----Probably will not use-----
E = entropyfilt(adjContr);

E = entropyfilt(grayImg);
Eim = rescale(E);
%}

subplot(3,3,3), imshow(adjContr);
title('Step-3: Adjust the contrast');

%{
BW1 = imbinarize(Eim,.8);
BWao = bwareaopen(BW1,1100);
BWao = imerode(BWao,se);
%9*9 neighbourhood
nhood = true(9);
%BWao = imerode(BWao,se);
BWao = imclose(BWao,nhood);
roughMask = imfill(BWao,'holes');
%}

BW1 = imbinarize(adjContr);
I = imcomplement(BW1);
I = bwareafilt(I,[900 1400]);
I = imclose(I,se);

nhood = true(5);
roughMask = imdilate(I,nhood);
roughMask = imcomplement(roughMask);
subplot(3,3,4), imshow(roughMask);
title('Step-4: Mask Template');

E2 = entropyfilt(grayImg);
E2im = rescale(E2);
subplot(3,3,6), imshow(E2im);
title('Step-6: Layered Mask');

texture1 = adjContr;
texture1(~roughMask) = 255;
texture2 = adjContr;
texture2(roughMask) = 255;

subplot(3,3,7), imshow(texture1);
title('Step-7: Where are the starfish...?');

subplot(3,3,8), imshow(texture2);
title('Step-8: ...There are the starfish!');

%{
boundary = bwperim(mask2);
segmentResults = redNoise;
segmentResults(boundary) = 0;
subplot(3,3,9), imshow(segmentResults);
title('Step-9: Final Output?');
%}