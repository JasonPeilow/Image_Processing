clear; close all; clc;

se1 = strel('cube', 4);
se2 = strel('disk', 2);

I = imread('Starfish.jpg');

I = rgb2gray(I);
E = entropyfilt(I);
Eim = rescale(E);

level = graythresh(Eim); % 0.7725%
BW1 = imbinarize(Eim, 0.81);

CC = bwconncomp(BW1);
L = labelmatrix(CC);

props = regionprops(CC, 'eccentricity');
idx = ( [props.Eccentricity] > 0.65);

BW2 = ismember(L,find(idx));    %# filter components with Eccentricity>0.6
BW3 = ismember(L,find(~idx));   %# filter components with Eccentricity<0.6

figure
subplot(241), imshow(Eim)
subplot(242), imshow(BW1)
subplot(243), imshow(BW2)
subplot(244), imshow(BW3)

BW4 = imclose(BW3, se1);
subplot(245), imshow(BW4)

BW5 = imfill(BW4, 'holes');
subplot(246), imshow(BW5)

BW6 = bwareaopen(BW5,400);
subplot(247), imshow(BW6)

BW7 = imclose(BW6, se2);
subplot(248), imshow(BW7)