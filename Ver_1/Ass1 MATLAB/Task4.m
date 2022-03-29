% MATLAB script for Assessment Item-1
% Task-4
clear; close all; clc;

%  REFERENCE BOOKS WHERE POSSIBLE
%% -------- Step 1: Read image, Create Structuring Element and Convert to GS --------

se = strel ( 'diamond' , 2 ); % Diamond shaped structuring element (additional pixel in size)
I = imread ( 'Starfish.jpg' ); % Read in starfish.jpg

% output original image
subplot ( 2 , 3 , 1 ) , imshow ( I ); 
title('Step-1: Default Image');


%% -------- Step 2: Filter Image and Adjust Contrast. --------

I = rgb2gray ( I ); % Convert to grayscale
I = medfilt3 ( I ); % Median Filter
% low_in (0.85) = The contrast limit for the lowest value
% high_in (1.0) = The contrast limit for the highest value
I = imadjust ( I , [ 0.85 1.0 ] , [] ); % Adjust the contrct of the image to make the strafish more prominant

% output filtered image with altered contract
subplot ( 2 , 3 , 2 ) , imshow ( I ); 
title('Step-2: Adjust the contrast');

%% -------- Step 3: Binarize and Morph the Image --------

I = imbinarize ( I ); % Binarize the image
I = imcomplement ( I ); % Invert the binarization
I = imfill ( I , 'holes' ); % Fill any existin holes in the image
I = imopen ( I , se ); % Perform opening: dilation then erosion
I = bwareaopen ( I , 150 ); % Remove any items with an area less than 150
subplot( 2 , 3 , 3 ) , imshow ( I ); 
title ( 'Step-3: Binarized image' );


%% -------- Step 4: Region Properties --------

format short %Shorten the format of the number output

% Region properties of each component measured from the centroid
stats1 = regionprops ( 'table' , I , 'Centroid' ,... 
    'MajorAxisLength' , 'MinorAxisLength' )
% The most minor and major axis length from the centroid are put into table

MinLength = stats1.MinorAxisLength ( : , 1 ); % Major axis extracted from region props
MaxLength = stats1.MajorAxisLength ( : , 1 ); % Minor axis extracted from region props

% Take stats from each colum for the table
starStatsMax = [ MaxLength(3,1); MaxLength(9,1); MaxLength(13,1); MaxLength(22,1); MaxLength(26,1) ]; % Array of maximum values of regions
starStatsMin = [ MinLength(3,1); MinLength(9,1); MinLength(13,1); MinLength(22,1); MinLength(26,1) ]; % Array of minimum values of regions

% List all of the stars as S1 to S5
allVar = [ "S1"; "S2"; "S3"; "S4"; "S5"; ]; 
stats2 = table ( allVar , starStatsMax , starStatsMin , 'VariableNames' ,... % Reformat a table...
    { 'StarFish' , 'MajorAxisLength' , 'MinorAxisLength' } ) % Major and Minor axis length of the five starfish only.


%% -------- Step 5: Boundary of Every Object --------

BW = I; % Initiate the input image as BW
% B = Row and column coordinates of the boundaries
% L = The continuous regions are labelled
% N = Objects are returned as a nonnegative integer
% A = Parent child dependencies (This is the space between boundaries)

% E.g enclosing boundary = find(A(m,:));
%     enclosed_boundaries = find(A(:,m));
[ B , L , N , A ] = bwboundaries ( BW ); 
% Establish array for boundaries

subplot( 2 , 3 , 4 ) , imshow ( BW );
title('Step-4: All object Boundaries');

hold on % Start drawing lines

% For loop to find the size of each boudary
for k = 1 : length ( B ) ,
    % for each 'k present the boundary s variable 'outline'
    outline = B { k } ;
    % Plot the outline, in Cyan with a width of 2.
    plot ( outline ( : , 2 ) , outline ( : , 1 ),...
        'c' , 'LineWidth' , 2 );
  
    % output and plot each boundary
    hold on;
    % Set the text output for each component
    % 'k' is looped and counter while being assigned to each component
    objNumber = text ( mean ( outline (: , 2 ) -3 ) , mean ( outline ( : , 1 ) -3 ) , num2str ( k ) );
    set ( objNumber , 'Color' , 'm' ,'FontSize' , 11 , 'FontWeight' , 'bold' );
end


%% -------- Step 6: Create Signature of Starfish 4 --------

% Signature - Starfish 4
% This is the 22nd objects in the cell array B 
signature = B { 22 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 2 , 3 , 5 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis
title ( 'Step 5: Starfish Signature' ); 


%% -------- Step 7: Only Present "matches" of S4 (S2 - S5) --------

pickUpFish = bwlabel ( BW ); % Assign labels to objects so starfish can be displayed

Jrows = 362; % Output image rows
Jcols = 438; % Output image columns

% Logical for loop because the object is true for a starfish or 
% Zeros matrix is the template for the output
fiveStarOutput = logical ( zeros ( Jrows , Jcols ) ); % Looks for the output of the five stars

for cycleObjects = 1 : N % for loop to cycle through all of the objects
    outline = B { cycleObjects } ; % find the boundary of each compnent
    % Angles which determine the plotting of the line theta and rho
    % Cartesian coordinates are converted to polar
    % Theta = Angular coordinate. Values angle in the range of [ -pi pi]
    % Rho = Radial coordinate. Distance from origin in the x-y plane
    [ theta , rho ] = cart2pol ( floor ( outline ( : , 2 ) ) ... % second column of the outline variable...
    - mean ( outline ( : , 2 ) ), ...                            % ...we get the mean so the avg is removed (This gives the bell curve)
    ( floor ( outline ( : , 1 ) ...                              % first column of the outline variable...
    - mean ( outline ( : ,1 ) ) ) ) );                           % ...we get the mean so the avg is removed (This gives the bell curve)
    
    justTheTips = findpeaks ( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Label the peaks so they may be detected
    % pks = This returns a vector of the local maxima peaks
    % locs = Peak locations returned as a vector
    [ pks , locs , widths , proms ] = findpeaks ( rho , 5 ); % For five peaks in each objects
    
    % Peak widths = returned as a vector of real numbers
    % Widths of the shapes are presented
    widths;
    % Proms = This is exactly what measures how much a point stands out
    % The most prominant points of the objects are outputted for insertion
    % into the table.
    proms;
    
    if length ( justTheTips ) == 4                      % If the size of the peaks array, the assumption is that it is a starfish
       w = mean ( widths );                             % Does not work, but tried to populate array (widths)
       p = mean ( proms );                              % Does not work, but tried to populate array (proms)
       fiveStarOutput = ...                             % The overall output
       fiveStarOutput + ( pickUpFish == cycleObjects ); % If pickUpFish is equal to the objects which are being cycled in the for loop
    end
end

stats3 = table ( widths , proms , 'VariableNames' ,...
    { 'MeanWidth', 'MeanProms' } )

subplot ( 2 , 3 , 6 ), imshow ( fiveStarOutput ); 
title ( 'Step 6: Final Output' );


%% -------- Step 8: Output of Five StarFish Objects  --------

newFish = size ( fiveStarOutput ); % resized image matrix

Label = bwlabel ( fiveStarOutput , 8 ); % Label components with a connectivity of 8
CC = regionprops( Label , 'BoundingBox' ); % Create a bounding box to segment each individual image

maxLabel = max ( Label ( : ) ); % Set variable to get the max label
starCell = cell( maxLabel , 1 ); % Output the cells containing the starfish

for i = 1 : maxLabel % For each lable, until max value is reached...

      starBox = ceil ( CC (i).BoundingBox ); % For each component in a bounding box, assign to an individual variable
      
      % Set markers for each corner of every bounding box
      X = [ starBox( 1 )-2 starBox( 1 )+ starBox( 3 ) +2 ]; 
      Y = [ starBox( 2 )-2 starBox( 2 )+ starBox( 4 ) +2 ];
      
      % If a component is detected then act on boundaries
      if X( 1 ) < 1, X( 1 ) = 1; end
      if Y( 1 ) < 1, Y( 1 ) = 1; end
      if X( 2 ) > newFish( 2 ), X( 2 ) = newFish ( 2 ); end
      if Y( 2 ) > newFish( 1 ), Y( 2 ) = newFish ( 1 ); end

      % Extract chosen object (Cropping)
      labelStar = Label == i;
      starCell{i} = labelStar( Y( 1 ) : Y( 2 ) , X( 1 ) : X( 2 ) );
end

figure

for i = 1 : maxLabel
    subplot( 5 , 1 , i )             % Loops through the subplots
    imshow( starCell{i} )            % Visualise the starfish
    title (['Object ', num2str(i)]); % Take value for i and convert to string
end


%% -------- Step 9: Output of Five StarFish Signatures  --------

figure

% Signature 1 -----------

% This is the 22nd objects in the cell array B 
signature = B { 3 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 5 , 1 , 1 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis


% Signature 2 -----------

% This is the 22nd objects in the cell array B 
signature = B { 9 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 5 , 1 , 2 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis


% Signature 3 -----------

% This is the 22nd objects in the cell array B 
signature = B { 13 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 5 , 1 , 3 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis


% Signature 4 -----------

% This is the 22nd objects in the cell array B 
signature = B { 22 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 5 , 1 , 4 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis


% Signature 5 -----------

% This is the 22nd objects in the cell array B 
signature = B { 26 };

% Expression is expressed 1Dimensionally
% The second column of this output (The boundary) is selected
% The first column of the signature is also taken and converted
% Once they are in the form of cartesian coordinates they can be plotted
[ theta, rho ] = cart2pol ( signature ( : , 2 ) - mean ( signature ( : , 2 ) ), ...
signature ( : , 1 ) - mean ( signature ( : , 1 ) ) );

hold on
minPoints = findpeaks( rho , 'MinPeakProminence' , 5 , 'Annotate' , 'extents' ); % Displays highlighted peaks in the signature

subplot( 5 , 1 , 5 ) , plot ( theta , rho , 'm.' );  % line is outputted in magenta
axis ( [ -pi pi 0 50 ] ); % This relates the the output / angles of the theta and rho line
xlabel ( 'radian' ); % Label along the x axis
ylabel ( 'r' ); % Label along the y axis

