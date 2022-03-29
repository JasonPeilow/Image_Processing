% MATLAB script for Assessment Item-1
% Task-2
clear; close all; clc;

% Step-1: Load input image
A = im2double(imread('Noisy.png'));
A = rgb2gray(A);
B = padarray(A, [2 2], 0);
[m,n] = size(B);

%{
avgFilter = @(x) mean(x(:))
A_filtered1 = nlfilter(B,[5 5], avgFilter);
subplot(1,3,2), imshow(A_filtered1)
title('Step-2: Mean filter');

medFilter = @(x) median(x(:))
A_filtered2 = nlfilter(B,[5 5], medFilter);
subplot(1,3,3), imshow(A_filtered2)
title('Step-3: Median filter');
%}

%MEAN/AVERAGING/MOVING AVERAGE FILTER----------

%Mean filter replaces the intesity value of that pixel by the mean value
%of that pixel

subplot(1,3,1), imshow(A)
title('Step-1: Default Image');

for i=1:m
        for j=1:n
            
            rmin = max(1,i-2);
            rmax = min(m,i+2);
            cmin = max(1,j-2);
            cmax = min(n,j+2);
            
            %Now the neighbourhood matrix, denoting it by temp
            temp = B(rmin:rmax,cmin:cmax);
            
            %now the ith pixel of the output will be the average of this neighbourhood.
            outputAvg(i,j) = mean(temp(:)); 
            outputMed(i,j) = median(temp(:));
        end
end

subplot(1,3,2),imshow(outputAvg)
title('Step-2: 5*5 Averaging filter');

%MEDIAN FILTER----------



subplot(1,3,3),imshow(outputMed)
title('Step-3: 5*5 Median filter');
            