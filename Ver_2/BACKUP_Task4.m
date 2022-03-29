% MATLAB script for Assessment Item-1
% Task-4
clear; close all; clc;


% -------- Step 1: Read image, Create Structuring Element and Convert to GS --------

se = strel('diamond',2);

I = imread('Starfish.jpg');
subplot(2,2,1), imshow(I);
title('Step-1.a: Default Image');

% -------- Step 2: Filter Image and Adjust Contrast. --------

I = rgb2gray(I);
I = medfilt2(I);
I = imadjust(I,[0.85 1.0],[]); %levels of threshold? > binarize this way > 150?
subplot(2,2,2), imshow(I);
title('Step-1.b: Adjust the contrast');

% -------- Step 3: Binarize and Morph the Image --------

I = imbinarize(I);
I = imcomplement(I);
I = imfill(I, 'holes');
I = imopen(I,se);
I = bwareaopen(I,150);
subplot(2,2,3), imshow(I);
title('Step-1.c: Binarized image');


% -------- Step 4: Region Properties --------

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
    {'StarFish','MajorAxisLength', 'MinorAxisLength'})


% -------- Step 5: Boundary of Every Object --------

BW = I;
[B,L,N,A] = bwboundaries(BW);

subplot(2,2,4), imshow(BW); hold on;

for k = 1:length(B),
  boundary = B{k};
  plot(boundary(:,2), boundary(:,1),...
       'c','LineWidth',2);
   
  hold on;
  h = text(mean(boundary(:,2)-3), mean(boundary(:,1)-3),num2str(k));
  set(h,'Color','m','FontSize',11,'FontWeight','bold');
end

% -------- Step 6a: Cropping of ALL Objects --------

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
    subplot(6,5,i)
    imshow(ObjCell{i})
    title(['Object ', num2str(i)]);
end
clear im L bb n i bb_i idx_x idx_y siz

% -------- Step 6b: Signature of ALL Objects --------

figure
subplotrow = ceil(sqrt(N));

for cnt = 1:N
boundary = B{cnt};
[th, r] = cart2pol(boundary(:,2) -mean(boundary(:,2)), ...
boundary(:,1) -mean(boundary(:,1)));

subplot(subplotrow,N/subplotrow,cnt);
plot(th,r,'c.');
axis([-pi pi 0 50]); %Radius
xlabel('radian');ylabel('r');
title(['Object ', num2str(cnt)]);
end


% -------- Step 7: Create Signature of Starfish 4 --------

%Signature - Starfish 4
figure

Signature = B{22};
[th, r]=cart2pol(Signature(:,2)-mean(Signature(:,2)), ...
Signature(:,1)-mean(Signature(:,1)));
hold on
plot(th,r,'k.');
axis([-pi pi 0 50]);
xlabel('radian');
ylabel('r');
title('Signature of Starfish 4');

detectMatch = bwlabel(BW);


% -------- Step 8: FINAL OUTPUT - Only Present "matches" of Signature --------

figure;
newimg = logical(zeros(362,438)); %%setting new image for the starfish
for cnt = 1:N
    boundary = B{cnt};
    [th, r] = cart2pol (floor(boundary(:,2)) - mean(boundary(:,2)), ...
    (floor(boundary(:,1)-mean(boundary(:,1))))); %%coverting the cordinetns 
    
    z = findpeaks(r,'MinPeakProminence',5);
    
    if length(z) == 4; %% this is the values for the for loop 
        newimg = newimg + (detectMatch == cnt); %%assumintg that it has 4 peaks
    end
end

imshow(newimg);
title('getting rid of the extras in the image');














