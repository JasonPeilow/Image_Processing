% MATLAB script for Assessment Item-1
% Task-4
clear; close all; clc;


% -------- Step 1.a: Read image, Create Structuring Element and Convert to GS --------

se = strel('diamond',2);

I = imread('Starfish.jpg');
subplot(1,3,1), imshow(I);
title('Step-1.a: Default Image');

% -------- Step 1.b: Filter Image and Adjust Contrast. --------

I = rgb2gray(I);
I = medfilt2(I);
I = imadjust(I,[0.85 1.0],[]); %levels of threshold? > binarize this way > 150?
subplot(1,3,2), imshow(I);
title('Step-1.b: Adjust the contrast');

% -------- Step 1.c: Binarize and Morph the Image --------

I = imbinarize(I);
I = imcomplement(I);
I = imfill(I, 'holes');
I = imopen(I,se);
I = bwareaopen(I,150);
subplot(1,3,3), imshow(I);
title('Step-1.c: Binarized image');



% -------- Step 2.a: Crop each object from the image --------

s = size(I); % image dimensions !! s means size
% Label the disconnected foreground regions (using 8 conned neighbourhood)
L = bwlabel(I,8); %changed from bwlabel to logical to save memory?

% Get the bounding box around each object
bb = regionprops(L,'BoundingBox');

% Crop the individual objects and store them in a cell
n = max(L(:)); % number of objects
ObjCell = cell(n,1);
for i = 1:n
      % Get the bb of the i-th object and offest by 2 pixels in all
      % directions
      bb_i = ceil(bb(i).BoundingBox);
      
      idx_x = [bb_i(1)-2 bb_i(1)+ bb_i(3) +2];
      idx_y = [bb_i(2)-2 bb_i(2)+ bb_i(4) +2];
      
      if idx_x(1) < 1, idx_x(1)=1; end
      if idx_y(1) < 1, idx_y(1)=1; end
      if idx_x(2) > s(2), idx_x(2)=s(2); end
      if idx_y(2) > s(1), idx_y(2)=s(1); end
      
      % Crop the object and write to ObjCell
      im = L == i;
      ObjCell{i} = im(idx_y(1):idx_y(2),idx_x(1):idx_x(2));
end
% Visualize the individual objects

% looping and plotting
figure
for i = 1:n
    subplot(5,6,i)
    imshow(ObjCell{i})
    title(['Object ', num2str(i)]);
end
clear im L bb n i bb_i idx_x idx_y siz


% -------- Step 2.b: Boundary Signatures of every object --------



% -------- Step 2.c: Properties of Objects in the Image --------

format short

%add numerical list....if poss
stats1 = regionprops('table',I,'Centroid',...
    'MajorAxisLength','MinorAxisLength')

MinLength = stats1.MinorAxisLength(:,1);
MaxLength = stats1.MajorAxisLength(:,1);

starStatsMax = [MaxLength(3,1);MaxLength(9,1);MaxLength(13,1);MaxLength(22,1);MaxLength(26,1)];
starStatsMin = [MinLength(3,1);MinLength(9,1);MinLength(13,1);MinLength(22,1);MinLength(26,1)];

allVar = ["S1"; "S2"; "S3"; "S4"; "S5";]; %For my reference
stats2 = table(allVar, starStatsMax, starStatsMin, 'VariableNames',...
    {'StarFish','MajorAxisLength', 'MinorAxisLength'}) %AND RATIO?






% -------- Step 3: Creare signature/convex hull of Starfish (S1). --------

%# get boundary
B = bwboundaries(ObjCell, 8, 'noholes');
B = B{1};

%%# boudary signature
%# convert boundary from cartesian to ploar coordinates
objB = bsxfun(@minus, B, mean(B));
[theta, rho] = cart2pol(objB(:,2), objB(:,1));

%# find corners
%#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
[~,order] = sort(rho, 'descend');
corners = order(1:10);

%# plot boundary signature + corners
figure, plot(theta, rho, '.'), hold on
plot(theta(corners), rho(corners), 'ro'), hold off
xlim([-pi pi]), title('Boundary Signature'), xlabel('\theta'), ylabel('\rho')

%# plot image + corners
figure, imshow(BW), hold on
plot(B(corners,2), B(corners,1), 's', 'MarkerSize',10, 'MarkerFaceColor','r')
hold off, title('Corners')
figure

%Crop starfish
S4 = ObjCell(22);
%Boundary of S1

%%# boudary signature
%# convert boundary from cartesian to ploar coordinates
boundary = B{i};
[theta, rho] = cart2pol(floor(boundary(:,2), boundary(:,1)));

%# find corners
%#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
[~,max] = sort(rho, 'descend');
[~,min] = sort(rho,'ascend');
convex = max(1:50);
concave = min(1:50);

%# plot boundary signature + corners
subplot(3,3,5), plot(theta, rho, 'go'), hold on
plot(theta(convex), rho(convex), 'ro'), 
plot(theta(concave), rho(concave), 'bo'),
hold off, title('Step-5: Min and Max values of all objects'), xlabel('\theta'), ylabel('\rho') 
xlim([-pi pi]), %MAX

%# plot image + corners
subplot(3,3,6), imshow(I), hold on
plot(S4(convex,2), S4(convex,1), 'ro', 'MarkerSize',5, 'MarkerFaceColor','w') %MAX
plot(S4(concave,2), S4(concave,1), 'bo', 'MarkerSize',5, 'MarkerFaceColor','w') %MIN
hold off, title('Step-5: Min and Max values of all objects')


% -------- Step 8: Compare S1 with every signature --------




% -------- Step 9: FINAL OUTPUT - Only Present "matches" of S1 (S2 - S5) --------













