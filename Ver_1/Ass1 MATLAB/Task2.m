%% MATLAB script for Assessment Item-1
% Task-2
clear; close all; clc;


%% -------- Step 1: Read image, Convert to Grayscale and Add Padding --------

A = im2double( imread ( 'Noisy.png' ) ); % Double precision needed for averaging sums.
A = rgb2gray ( A ); % Two dimensions are easier to work with that three.
B = padarray ( A , [ 2 2 ] , 0 ); % 2*pixel padding compensates for loss (Using a 5*5 kernel)
[ m , n ] = size ( B ); % returns the size of the input image as seperate m*n variables.

subplot ( 3 , 1 , 1 ) , imshow ( A ) , title ( 'Step-1: Default Image' );


%% -------- Step 2: Mean & Median 5*5 Filter (Nested For Loop) --------

%Mean filter replaces the intesity value of that pixel by the mean value
%of that pixel

for i = 1 : m % for each i value of an iteration through m (columns)...
    for j = 1 : n % while for each j value of an iteration through n (columns)...
        % Neighbourhood of -2 or +2 for a 5*5 kernel
        rowMin = max ( 1 , i - 2 ); 
        rowMax = min ( m , i + 2 );
        colMin = max ( 1 , j - 2 ); 
        colMax = min ( n , j + 2 ); 
        % The above, colMax/Min and rowMax/Min, represent the boundaries of
        % the neighbourhood: (i-2,j-2), (i, j-2), (i+2,j-2)...etc.
            
        %Now the neighbourhood matrix, denoting it by temp? What?
        filter = B ( rowMin : rowMax , colMin : colMax );
            
        %now the ith and jth pixel of the output will be the average of this neighbourhood.
        avgFilt ( i , j ) = mean ( filter ( : ) );
        medFilt ( i , j ) = median ( filter ( : ) );
    end
end


%% -------- Step 3: FINAL OUTPUT - Averaging and Median Filter --------

% Disply results of mean/averaging filter
subplot ( 3 , 1 , 2 ) , imshow (avgFilt) , title ( 'Step-2: 5*5 Averaging filter' ); 

% Display results of median filter
subplot ( 3 , 1 , 3 ) , imshow (medFilt) , title ( 'Step-3: 5*5 Median filter' );
            