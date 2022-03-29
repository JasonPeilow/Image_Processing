%% MATLAB script for Assessment Item-1
% Task-3
clear; close all; clc;

%Structuring element / mask - iterates pixel by pixel
se1 = strel ( 'cube' , 4 ); % 4*4 pixel cube
se2 = strel ( 'disk' , 2 ); % 2*2 pixel disk

I = imread ( 'Starfish.jpg' );


%% -------- Step 1: Read image, Convert to Grayscale and Add Padding --------

%Without 3 channels, there are issues with background (shadow etc)

size ( I ) 

chanR = I ( : , : , 1 ); % Extract the red channel
chanG = I ( : , : , 2 ); % Extract the green channel
chanB = I ( : , : , 3 ); % Extract the blue channel

figure;

% Display colour channels
subplot ( 2 , 2 , 1 ) , imshow ( I ) , title ( 'Step 1.a: Original' );
subplot ( 2 , 2 , 2 ) , imshow ( chanR ) , title ( 'Step 1.b: Red Channel' ) , colorbar;
subplot ( 2 , 2 , 3 ) , imshow ( chanG ) , title ( 'Step 1.c: Green Channel' ) , colorbar;
subplot ( 2 , 2 , 4 ) , imshow ( chanB ) , title ( 'Step 1.d: Blue Channel' ) , colorbar;

newI = chanB; % Blue channel is the most prominant which displays the starfish


%% -------- Step 2: Entropy Filter and Binarization --------

E = entropyfilt ( newI ); % Entropy value is returned by a 9*9 neighbourhood.
Ei = rescale ( E ); % rescale the filtered image

level = graythresh ( Ei ); % Otsu thresholding
% Level is (generally): 0.7725%
BW1 = imbinarize ( Ei , 0.835 ); % Level needed to exceed to select starfish


%% -------- Step 3: Labelling Objects and Eccentricity --------

CC = bwconncomp ( BW1 ); % Finds connected componenets (CC) in the binary image
L = labelmatrix ( CC ); % Label matrix so individual components can be selected (using connected componenets).

props = regionprops ( CC , 'eccentricity' ); %Eccentricity of connected components. 
%1 is a line, anything close to 0 is circular/ellipse.
idx = ( [ props.Eccentricity ] > 0.70 ); % Components are indexed by eccentricity of more than 0.70. 

BW2 = ismember ( L , find ( idx ) );  %# filter labelled components with Eccentricity of more than 0.70
BW3 = ismember ( L , find ( ~idx ) ); %# filter labelled components with Eccentricity of less than 0.70 ( ~ is LOGICAL operator NOT)

%{
For my reference (From the Mathworks website):

'Eccentricity' — Scalar that specifies the eccentricity of the ellipse that has the same second-moments as the region. 
The eccentricity is the ratio of the distance between the foci of the ellipse and its major axis length. The value is between 0 and 1. 
(0 and 1 are degenerate cases; an ellipse whose eccentricity is 0 is actually a circle, while an ellipse whose eccentricity is 1 is a line segment.) 
This property is supported only for 2-D input label matrices.
%}


%% -------- Step 4: Read image, Convert to Grayscale and Add Padding --------

figure;

subplot ( 2 , 3 , 1 ) , imshow ( Ei ) , title ( 'Step 2: Entropy Filter' ); 
subplot ( 2 , 3 , 2 ) , imshow ( BW1 ) , title ( 'Step 3: Binarization of Filtered Image' ); 
subplot ( 2 , 3 , 3 ) , imshow ( BW2 ) , title ( 'Step 4: Components with an eccentricity < 0.70' ); 
subplot ( 2 , 3 , 4 ) , imshow ( BW3 ) , title ( 'Step 5: Components with an eccentricity > 0.70' ); 

BW4 = imclose ( BW3 , se1 ); % Closing morphology: Erosion then diliation
BW5 = imfill ( BW4 , 'holes' ); % All holes in components are filled in.

subplot ( 2 , 3 , 5 ) , imshow ( BW5 ) , title ( 'Step 6: Filling the holes of the components' );

BW6 = bwareaopen ( BW5 , 400 ); % All objects with an area > 400 are removed from the image
BW7 = imclose ( BW6 , se2 ); % Closing morphology: Erosion then diliation

subplot ( 2 , 3 , 6 ) , imshow ( BW7 ) , title ( 'Step 7: Removal of minor background elements' );
