% MATLAB script for Assessment Item-1
% Task-4.b
clear; close all; clc;

I = imread('Starfish.jpg')
I = rgb2gray(I);
subplot(2,2,1)
imshow(I)
iptsetpref ImshowBorder tight
I = medfilt2(I);
I = imadjust(I,[0.7 1.0],[]);

% segment by thresholding
thresh = 200;
lanes = imbinarize(I, thresh/255);
imshow(lanes);

%clean up image
lanes = bwareaopen(lanes,50);
subplot(2,2,2)
imshow(lanes);

%lane bounds
%lanes = imclearborder(lanes);
%imshow(lanes);
lane = imcomplement(lanes);

%find lanes
[B,L] = bwboundaries(lane, 'noholes');
numRegions = max(L(:));
subplot(2,2,3)
imshow(label2rgb(L));

%properties
imageStats = regionprops(L,'all');

%f

%keep objects that are not circular
shapes = [imageStats.Eccentricity];
keepers = find(shapes > 0.7);

%show image
subplot(2,2,4)
imshow(lanes);
for index = 1:length(keepers)
    outline = B{keepers(index)};
    line(outline(:,2),outline(:,1),'Color','r','LineWidth',6);
end

