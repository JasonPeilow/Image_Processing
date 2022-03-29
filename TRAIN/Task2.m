%% MATLAB script for Assessment Item-1
% Task-2
clear; close all; clc;


%% -------- Step 1: Read image, Convert to Grayscale and Add Padding --------

A = im2double( imread ( 'Noisy.png' ) );
A = rgb2gray ( A );
B = padarray ( A , [ 2 2 ] , 0 );
[ m , n ] = size ( B );

subplot ( 1 , 3 , 1 ) , imshow ( A ) , title ( 'Step-1: Default Image' );


%% -------- Step 2: Mean & Median 5*5 Filter (Nested For Loop) --------

%Mean filter replaces the intesity value of that pixel by the mean value
%of that pixel

for i = 1 : m % for each i value of an iteration through m (rows)...
        for j = 1 : n % for each j value of an iteration through n (columns)...
            
            rowMin = max ( 1 , i - 2 ); 
            rowMax = min ( m , i + 2 );
            colMin = max ( 1 , j - 2 );
            colMax = min ( n , j + 2 );
            
            %Now the neighbourhood matrix, denoting it by temp? What?
            temp = B ( rowMin : rowMax , colMin : colMax );
            
            %now the ith and jth pixel of the output will be the average of this neighbourhood.
            outputAvg ( i , j ) = mean ( temp ( : ) ); 
            outputMed ( i , j ) = median ( temp ( : ) );
            
        end
end


%% -------- Step 3: FINAL OUTPUT - Averaging and Median Filter --------

% 
subplot ( 1 , 3 , 2 ) , imshow ( outputAvg ) , title ( 'Step-2: 5*5 Averaging filter' );

% 
subplot ( 1 , 3 , 3 ) , imshow ( outputMed ) , title ( 'Step-3: 5*5 Median filter' );
            