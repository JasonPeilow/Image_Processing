% MATLAB script for Assessment Item-1
% Task-4
clear; close all; clc;

% -------- Step 1: Create structuring element --------

se = strel('diamond',2);

I = imread('Starfish.jpg');
subplot(2,3,1), imshow(I);
title('Step-1: Default Image');

% -------- Step 2: Convert image to grayscale. --------

I = rgb2gray(I);

% -------- Step 3: Filter image and adjust contrast. --------

I = medfilt2(I);
I = imadjust(I,[0.85 1.0],[]);
subplot(2,3,2), imshow(I);
title('Step-3: Adjust the contrast');

% -------- Step 4: Take properties of the objects region. --------

I = imbinarize(I);
I = imcomplement(I);
I = imfill(I, 'holes');
I = imopen(I,se);
I = bwareaopen(I,150);
subplot(2,3,3), imshow(I);
title('Step-4: Binarized image');

% -------- Step 5: Take properties of the objects region. --------

format short

stats1 = regionprops('table',I,'Centroid',...
    'MajorAxisLength','MinorAxisLength')

MinLength = stats1.MinorAxisLength(:,1);
MaxLength = stats1.MajorAxisLength(:,1);

[B,L,N,A] = bwboundaries(I);

subplot(2,3,4),imshow(I)
title('Step-5: Min and Max values of all objects');

for cnt = 1:N
hold on;
boundary = B{cnt};
plot(boundary(:,2), boundary(:,1),'g-'); 
hold on;
text(mean(boundary(:,2)), mean(boundary(:,1)),num2str(cnt)); %add colour etc
hold off
end

%{
COMPARE

for cnt = 1:N
boundary = B{cnt};
[th, r] = cart2pol(boundary(:,2)-mean(boundary(:,2)), ...
boundary(:,1)-mean(boundary(:,1)));
subplot(subplotrow,N/subplotrow,cnt);

plot(th,r,'.');
axis([-pi pi 0 50]); %Radians of signature
xlabel('radian');ylabel('r');
title(['Object ', num2str(cnt)]);
end
%}



starStatsMax = [MaxLength(3,1);MaxLength(9,1);MaxLength(13,1);MaxLength(22,1);MaxLength(26,1)];
starStatsMin = [MinLength(3,1);MinLength(9,1);MinLength(13,1);MinLength(22,1);MinLength(26,1)];

allVar = ["S1"; "S2"; "S3"; "S4"; "S5";]; %For my reference
stats2 = table(allVar, starStatsMax, starStatsMin, 'VariableNames',...
    {'StarFish','MajorAxisLength', 'MinorAxisLength'})


% -------- Step 6: Creare signature/convex hull of Starfish (S1). --------

%Crop starfish

%Boundary of S1
S4 = B{22};

%%# boudary signature
%# convert boundary from cartesian to ploar coordinates
objB = bsxfun(@minus, S4, mean(S4));
[theta, rho] = cart2pol(objB(:,2), objB(:,1));

%# find corners
%#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
[~,max] = sort(rho, 'descend');
[~,min] = sort(rho,'ascend');
convex = max(1:75);
concave = min(1:75);

%# plot boundary signature + corners
subplot(2,3,5), plot(theta, rho, 'go'), hold on
plot(theta(convex), rho(convex), 'ro'), 
plot(theta(concave), rho(concave), 'bo'),
hold off
xlim([-pi pi]), title('Step-5: Min and Max values of all objects'), xlabel('\theta'), ylabel('\rho') %MAX

%# plot image + corners
subplot(2,3,6), imshow(I), hold on
plot(S4(convex,2), S4(convex,1), 'ro', 'MarkerSize',5, 'MarkerFaceColor','w') %MAX
plot(S4(concave,2), S4(concave,1), 'bo', 'MarkerSize',5, 'MarkerFaceColor','w') %MIN
hold off, title('Step-5: Min and Max values of all objects');

%----DIVIDE------
%{

figure;
subplotrow = ceil(sqrt(N));

for cnt = 1:N
boundary = B{cnt};
[theta, rho] = cart2pol(boundary(:,2)-mean(boundary(:,2)), ...
boundary(:,1)-mean(boundary(:,1)));
subplot(subplotrow,N/subplotrow,cnt);

plot(theta,rho,'r.');
axis([-pi pi 0 50]); %Radians of signature
xlabel('radian');ylabel('r');
title(['Object ', num2str(cnt)]);
end
%}
% -------- Step 7: Compare S1 with every signature --------

%Use sum of square difference
%ALL OBJECTS
B2 = reshape(B',[31 1]);
newB = cell2mat(B2);

% -------- Step 8: FINAL OUTPUT - Only Present "matches" of S1 (S2 - S5) --------