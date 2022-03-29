% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

se = strel('disk',3);

I = imread('Starfish.jpg');
subplot(2,2,1), imshow(I);
title('Step-1: Default Image');

I = rgb2gray(I);
subplot(2,2,2), imshow(I);
title('Step-2: Convert to Grayscale');

I = medfilt2(I);
I = imadjust(I,[0.7 1.0],[]);
subplot(2,2,3), imshow(I);
title('Step-3: Adjust the contrast');

I = imbinarize(I);
I = imcomplement(I);
I = bwareafilt(I,[900 1400]);
I = imclose(I,se);
subplot(2,2,4), imshow(I);
title('Step-4: Final output');

%THE ABOVE IS JUST TEMPORARY. 
L1 = bwlabeln(I);
%Task 4-A: Boundary Descriptor.


%Task 4-B: Regional Descriptor.
s1 = regionprops(L1,'Area','BoundingBox', 'Extrema','Centroid');
boxes = cat(1,s1.BoundingBox);
left_edge = boxes(:,1);
[sorted,sort_order] = sort(left_edge);
s2 = s1(sort_order);

hold on
for k = 1:numel(s2)
    centroid = s2(k).Centroid
    text(centroid(1),centroid(2),sprintf('%d',k));
end
hold off

%Task 4-C: Structural Descriptor.

