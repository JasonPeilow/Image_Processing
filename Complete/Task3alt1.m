% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se1 = strel('disk',3);
se2 = strel('disk',2);

Img = imread('Starfish.jpg');
subplot(2,2,1), imshow(Img);
title('Step-1: Original Image');

grayImg = rgb2gray(Img);
subplot(2,2,2), imshow(grayImg);
title('Step-2: Convert to Grayscale');

%Entropy is a statistical measure of randomness that can be used to characterize the texture of the input image.
Ent = entropyfilt(grayImg);
%Rescale for a double image
resEnt = rescale(Ent);
%How much entropy?
%The sand and the shells
subplot(2,2,3), imshow(resEnt);
title('Step-3: Entropy filter');

BW = imbinarize(resEnt, .79);
BW1 = imopen(BW,se1);
BWs = bwselect(BW1,4);
%BW2 = bwareafilt(BW1,[1800 2200]);

c = [43 185 212 200 200];
r = [38 68 181 200 150];
%Create a new binary image containing only the selected objects. This example specifies 4-connected objects.
BW2 = bwselect(BW1,c,r,4);

BW3 = imfill(BW2,'holes');
BW4 = imerode(BW3,se2);
subplot(2,2,4), imshow(BW4);
title('Step-4: Binarised starfish');

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

%{
BW1 = imbinarize(adjContr);
I = imcomplement(BW1);
I = bwareafilt(I,[900 1400]);
I = imclose(I,se);

nhood = true(5);
roughMask = imdilate(I,nhood);

subplot(3,3,4), imshow(roughMask);
title('Step-4: Mask Template');

%If you use a mask noise is not a factor
%It simply segments the area
Img2 = redNoise;
Img2(roughMask) = 0;
subplot(3,3,5), imshow(Img2);
title('Step-5: Final output');

E2 = entropyfilt(Img2);
E2im = rescale(E2);
subplot(3,3,6), imshow(E2im);
title('Step-6: Layered Mask');

BW2 = imbinarize(E2im);
mask2 = bwareaopen(BW2,1000);

texture1 = adjContr;
texture1(~mask2) = 255;
texture2 = adjContr;
texture2(mask2) = 255;

subplot(3,3,7), imshow(texture1);
title('Step-7: Where are the starfish...?');

subplot(3,3,8), imshow(texture2);
title('Step-8: ...There are the starfish!');


boundary = bwperim(mask2);
segmentResults = redNoise;
segmentResults(boundary) = 0;
subplot(3,3,9), imshow(segmentResults);
title('Step-9: Final Output?');
%}
