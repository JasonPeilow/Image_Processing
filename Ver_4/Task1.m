% MATLAB script for Assessment Item-1
% Task-1
clear; close all; clc;

% Step-1: Load input image
I = imread('Zebra.jpg');
%figure;
%imshow(I);
%title('Step-1: Load input image');

% Step-2: Conversion of input image to grey-scale image
Igray = rgb2gray(I);
%figure;
%imshow(Igray);
%title('Step-2: Conversion of input image to greyscale');

% Step-3: Resize the image by Nearest Neighbour Interpolation.
scale = [3 3]; %resolution scale factors: [rows columns]
oldSize = size(Igray);
newSize = max(floor(scale.*oldSize(1:2)),1);

% 3a: compute an upsampled set of indices:
rowIndex = min(round(((1:newSize(1))-0.5)./scale(1)+0.5),oldSize(1));
colIndex = min(round(((1:newSize(2))-0.5)./scale(2)+0.5),oldSize(2));

% 3b: index old image to get new image:
outputImage = Igray(rowIndex,colIndex,:);
%imshow(outputImage);
%title('Step-3: Nearest Neighbour Interpolation');

out = bilinearInterpolation(Igray, [1668 1836]);
figure
%imshow(out);
%title('Step-4: Bilinear Interpolation');

subplot(1,2,1), imshow(outputImage);
title('Step-3: Nearest Neighbour Interpolation');
subplot(1,2,2), imshow(out);
title('Step-4: Bilinear Interpolation');

%Step-5: Crop the filtered images.
figure
%[J, rect] = imcrop(outputImage);
cropped1 = imcrop(outputImage,[300 430 200 200]);
subplot(1,2,1),imshow(cropped1)
title('Step-5a: Crop and Zoom of Nearest Neighbour Interpolation', 'FontSize', 18);

%[J, rect] = imcrop(out);
cropped2 = imcrop(out,[300 430 200 200]);
subplot(1,2,2),imshow(cropped2)
title('Step-5b: Crop and Zoom of Bilinear Interpolation', 'FontSize', 18);