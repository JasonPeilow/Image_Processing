% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se1 = strel('cube', 4); %Structuring element / mask - iterates pixel by pixel
se2 = strel('disk', 2); %Aka, morphological tool

I = imread('Starfish.jpg');

% -------- Step 1:  --------

%Without 3 channels, there are issues with background (shadow etc)
size(I)
img1_r = I( :, :, 1 );
img1_g = I( :, :, 2 );
img1_b = I( :, :, 3 );

figure, subplot(2, 2, 1), imshow(I), title('Original');
subplot(2, 2, 2), imshow(img1_r), title('Red'), colorbar;
subplot(2, 2, 3), imshow(img1_g), title('Green'), colorbar;
subplot(2, 2, 4), imshow(img1_b), title('Blue'), colorbar;

newI = img1_b ;

E = entropyfilt(newI); %Entropy Shannon-coding
Eim = rescale(E);
%https://blogs.mathworks.com/steve/2012/11/13/image-effects-part-1/#ada70574-d465-47d2-867c-0d100b3ce654

level = graythresh(Eim); % 0.7725%
BW1 = imbinarize(Eim, 0.835);

CC = bwconncomp(BW1)%Find connected components
L = labelmatrix(CC);

props = regionprops(CC, 'eccentricity');
idx = ( [props.Eccentricity] > 0.70); %1 is a line, anything close to 0 is circular.

%{
'Eccentricity' — Scalar that specifies the eccentricity of the ellipse that has the same second-moments as the region. 
The eccentricity is the ratio of the distance between the foci of the ellipse and its major axis length. The value is between 0 and 1. 
(0 and 1 are degenerate cases; an ellipse whose eccentricity is 0 is actually a circle, while an ellipse whose eccentricity is 1 is a line segment.) 
This property is supported only for 2-D input label matrices.
%}
BW2 = ismember(L,find(idx));  %# filter components with Eccentricity>0.6
BW3 = ismember(L,find(~idx)); %# filter components with Eccentricity<0.6

% -------- Step 2:  --------

figure
subplot(2, 3, 1), imshow(Eim), title('Red');%Actually a binary image
subplot(2, 3, 2), imshow(BW1), title('Red'); 
subplot(2, 3, 3), imshow(BW2), title('Red');%Difference in Eccentricity
subplot(2, 3, 4), imshow(BW3), title('Red');

BW4 = imclose(BW3, se1);
BW5 = imfill(BW4, 'holes');
subplot(2, 3, 5), imshow(BW5), title('Red');

BW6 = bwareaopen(BW5,400);
BW7 = imclose(BW6, se2);
subplot(2, 3, 6), imshow(BW7), title('Red');