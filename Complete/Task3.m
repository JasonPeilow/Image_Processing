% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se = strel('disk',2);

Img = imread('Starfish.jpg');
subplot(2,3,1), imshow(Img);
title('Step-1: Default Image');

grayImg = rgb2gray(Img);
subplot(2,3,2), imshow(grayImg);
title('Step-2: Convert to Grayscale');

%Reduce the noise in the image
%redNoise = medfilt2(grayImg);
%{ 
-----Probably will not use-----
adjContr = imadjust(redNoise,[0.7 1.0],[]);
E = entropyfilt(adjContr);
%}

%adjContr = imadjust(grayImg,[0.8 0.9],[]);
E = entropyfilt(grayImg);
Eim = rescale(E);

subplot(2,3,3), imshow(Eim);
title('Step-3: Adjust the contrast');

BW1 = imbinarize(Eim,.8);
%BWao = bwareaopen(BW1,1000);
BWao = bwareafilt(BW1,[1800 2200]);
BWao = imerode(BWao,se);
%9*9 neighbourhood
nhood = true(9);
%BWao = imerode(BWao,se);
BWao = imclose(BWao,nhood);
roughMask = imfill(BWao,'holes');
%{
I = imcomplement(I);
I = bwareafilt(I,[900 1400]);
I = imclose(I,se);
%}
subplot(2,3,4), imshow(roughMask);
title('Step-4: Final output');

%If you use a mask noise is not a factor
%It simply segments the area
Img2 = grayImg;
Img2(roughMask) = 0;
subplot(2,3,5), imshow(Img2);
title('Step-4: Final output');

E2 = entropyfilt(Img2);
E2im = rescale(E2);
subplot(2,3,5), imshow(E2im);
title('Step-4: Final output');

BW2 = imbinarize(E2im);
compBW2 = imcomplement(BW2);
subplot(2,3,6), imshow(compBW2);
title('Step-4: Final output');