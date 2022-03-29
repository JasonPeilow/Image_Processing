% MATLAB script for Assessment 1
clear; close all; clc;

%% Task-1

% Step-1: Load input image

I = imread ('C:\Users\Jason Laptop\Downloads\Assignment_Input\Assignment_Input\Swan logo recognition\IMG_01.JPG');
X = imread ('C:\Users\Jason Laptop\Downloads\Assignment_Input\Assignment_Input\Swan logo recognition\IMG_01.JPG');
Y = imread ('C:\Users\Jason Laptop\Downloads\Assignment_Input\Assignment_Input\Swan logo recognition\IMG_01.JPG');

% Step-2a: Conversion of input image to grey-scale image

Igray = rgb2gray(I);

% Step-2b: Break image down into RGB values

Red =   X(:, :, 1);
Green = X(:, :, 2);
Blue =  X(:, :, 3);

makeGray = 0.2989 * Red ...
         + 0.5870 * Green ...
         + 0.1140 * Blue;

% Step-2c: Break image down into RGB values

% RGB can be used twice, is there a need for reallocation? I think not

Red2 =   Y(:, :, 1);
Green2 = Y(:, :, 2);
Blue2 =  Y(:, :, 3);

makeGray2 = 0.2989 * double(Red2) ...
          + 0.5870 * double(Green2) ...
          + 0.1140 * double(Blue2);

makeGray2 = uint8(makeGray2);

% Histograms of Igray and makeGray to check efficiency of custom process
figure;
subplot (1, 3, 1), histogram(Igray), title('oriGray');
subplot (1, 3, 2), histogram(makeGray), title('customGray');
subplot (1, 3, 3), histogram(makeGray2), title('dataGray');


figure;
subplot (2, 2, 1), imshow(I), title('ONE');
subplot (2, 2, 2), imshow(Igray), title('TWO');
subplot (2, 2, 3), imshow(makeGray), title ('THREE'); % Limit the size
subplot (2, 2, 4), imshow(makeGray2), title ('FOUR'); % Limit the size

% Slight difference in the two histograms (Write more in depth description)
% DO THIS AT THE END OF EACH CRUCIAL STEP

% --------------------------------------------------------------------------------------------------------------

% Step-3: Resizing the grayscale image using bilinear interpolation

% 1-3a. Confirming the dimensions of the original image (3024 x 4032)
size(Igray)

% 1-3b. Reduce the image size by 50%
%J = imresize(Igray, 0.5);

% 1-3c. Designate rows (m) and columns(n) for the input function
[m, n] = size(Igray);

% Bilinear Interpolation needs to be used to reduce the image by half
% NOT reduce the image by half THEN use Bilinear Interpolation
r = m / 2;
c = n / 2;

% 1-3e. Call the Task1Func (Bilinear Interpolation) function
% Specify the size of the interpolated output (In Grayscale)
Ibili = Task1Func (Igray , [r c]); 
% !!!  You CAN use any built-in function but not any custom functions written by others (e.g. from Matlab File Exchange).

% Step-4: Comparison of cropped images post Bilinear Interpolation

%{
[J, rect] = imcrop(outputImage);
cropNN = imcrop (Nearest , [300 430 200 200]); %used the imcrop feature to select the range of pixels
subplot (1 , 2 , 1) , imshow (cropNN), title ('Step-5.i: Crop and Zoom of Nearest Neighbour Interpolation' , 'FontSize' , 18)

%[J, rect] = imcrop(out);
cropBI = imcrop ( Bilinear , [300 430 200 200]); %used the imcrop feature to select the range of pixels
subplot (1 , 2 , 2), imshow (cropBI), title ('Step-5.ii: Crop and Zoom of Bilinear Interpolation' , 'FontSize' , 18)
%}

% Step-5: Generating histogram for the resized image and Producing binarised image
threshold = 205;

% Thresholding at 205 means no imperfections within the swam
% However, thresholding at 210 causes the quality of the swam object to
% deprecate(right word?)
% I could perform a simple image inversion to make it match imbinarize

Ibin2 = Ibili < threshold; % Change the variable names
Ibin2 = ~Ibin2; % Simple inversion, using a tilda.

% SOME loss of image integrity within Ibin2

Ibin1 = imbinarize (Ibili);

% Present varying thresholds and compare?
% Although, this would make it look like I have no idea what I am doing
% Maybe compare, but limit it to 2 examples?


% Step-6: Completion of Task-1
figure;
subplot (2, 2, 1), imshow (Ibili), title ('Task 1.a: Resized Image using Bilinear Interpolation'); 
subplot (2, 2, 2), histogram(Ibili), title ('Task 1.b: Histogram of the Resized Image'); % Limit the size
subplot (2, 2, 3), imshow (Ibin1), title ('Task 1.c: Resized Image in Binary Format'); 
subplot (2, 2, 4), imshow (Ibin2), title ('Task 1.d: Resized Image in CUSTOM Binary Format'); 

% 1-3c. Cofirming the dimensions of the resized image (1512 x 2016)
size(Ibili)


% CUSTOM BILINEAR START !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% -------------------------------------------------------------------------

size(makeGray2)

% 1-3c. Designate rows (m) and columns(n) for the input function

[Rin, Cin] = size(Igray); % SIZE ORIGINAL IMAGE (
Rout_Cout = [2 2]; % SIZE OF SCALED IMAGE (50% in size)
Sr = Rin / Rout_Cout(1); % SCALE FACTOR: ROWS
Sc = Cin / Rout_Cout(2); % SCALE FACTOR: COLS

% Check the size of scaled factors
size(Sr) 
size(Sc)

% Prep the variables for the formula
Pbilin = zeros(Rout_Cout(1), Rout_Cout(2), size(Igray, 3));
Pbilin = cast(Pbilin, class(Igray));

% -------------------------------------------------------------------------

% SUBPIXEL LOCATION (Weighted averages?)
one_Rout = 1 : Sr;
one_Cout = 1 : Sc;

size(one_Rout)
size(one_Cout)

% Find alternative to mesh grid
subpixelLoc = meshgrid(one_Rout, one_Cout); % Name more appropriately
size(subpixelLoc)

[Rf, Cf] = size(subpixelLoc');



% -------------------------------------------------------------------------

% SUXPIXEL LOC: INTEGER PART
Ro = floor(Rf * Sr); % put into array positions?
Co = floor(Cf * Sc);

% CALCULATE FLOOR LIKE NN (MIN AND MAX ROUNDING)

integerPart = [Ro, Co];

% -------------------------------------------------------------------------
%{

                   (R_0, C_0)           (R_0, C_0 + 1)
                      ____                   ____
                     |    |_________________|    |
                     |____|                 |____|
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                      ____                   ____
                     |    |_________________|    |
                     |____|                 |____|

                 (R_0 + 1, C_0)       (R_0 + 1, C_0 + 1)



                  (R_0, C_0)      or      RoCo (Top Left)         
              (R_0, C_0 + 1)      or      RoCp (Bottom Left)
              (R_0 + 1, C_0)      or      RpCo (Top Right)
          (R_0 + 1, C_0 + 1)      or      RpCp (Bottom Right)

%}
% -------------------------------------------------------------------------

% ALTERNATIVES????

% ADJUST INDICES - Ensure it is not less than 1
Ro (integerPart(1) < 1) = 1;
Ro (integerPart(1) > Rin - 1) = Rin - 1;

Co (integerPart(2) < 1) = 1;
Co (integerPart(2) > Cin - 1) = Cin - 1;

% CREATE FIRST ORDER, 2D PLANE
setPoly = [Ro, (Ro + 1), Co, (Co  + 1)];

RoCo = sub2ind([Rin, Cin], setPoly(1), setPoly(3));
RoCp = sub2ind([Rin, Cin], setPoly(2), setPoly(3));
RpCo = sub2ind([Rin, Cin], setPoly(1), setPoly(4));
RpCp = sub2ind([Rin, Cin], setPoly(2), setPoly(4));

% A more efficient method perhaps?

polynomial = [RoCo, RoCp, RpCo, RpCp];

% -------------------------------------------------------------------------
%{

                   (R_0, C_0)           (R_0, C_0 + 1)
                      ____                   ____
                     |    |_________________|    |
                     |____|                 |____|
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                        |                     |
                      ____                   ____
                     |    |_________________|    |
                     |____|                 |____|

                 (R_0 + 1, C_0)       (R_0 + 1, C_0 + 1)



                  (R_0, C_0)      or      RoCo (Top Left)         
              (R_0, C_0 + 1)      or      RoCp (Bottom Left)
              (R_0 + 1, C_0)      or      RpCo (Top Right)
          (R_0 + 1, C_0 + 1)      or      RpCp (Bottom Right)

%}
% -------------------------------------------------------------------------

% FRACTAL PART
deltaR = (Rf - Ro);
deltaC = (Cf - Ro);

nonintergerLoc = [deltaR, deltaC];

% NOTICE HOW THE FRACTURES MIRROR THE INTEGERS....

% REMEMBER THE TILDA (~)

% (1 - dr) * (1 - dc)
A = (1 - nonintergerLoc(1)) * (1 - nonintergerLoc(2));
% dr * (1 - dc)
B = (nonintergerLoc(1)) * (1 - nonintergerLoc(2));
% (1 - dr) * dc
C = (1 - nonintergerLoc(1)) * (nonintergerLoc(2));
% dr * dc
D = (nonintergerLoc(1)) * (nonintergerLoc(2));

% DO they need rounding? This may be the case.

fractalParts = [A, B, C, D];

% Combine fractal part and polynomial to get complete plane???
% How much more can the formula be broken down?

% ADDING THE ABOVE, SIMPLIFIES THE BELOW

% -------------------------------------------------------------------------

% FOR LOOP TO CYCLE THROUGH IMAGE (IN PROGRESS)
% :) :) :) Pretty good that the issues only begin here lol



for indexInput = 1 : size(Igray, 3)
    
    Igray = double(Igray(:, :, indexInput)); % Change Igray to Channel (I)
    
    Jgray = Igray(polynomial(1)) .* (fractalParts(X)) .* (fractalParts(X)) ...  
          + Igray(polynomial(2)) .* (fractalParts(X)) .* (fractalParts(X)) ...
          + Igray(polynomial(3)) .* (fractalParts(X)) .* (fractalParts(X)) ...
          + Igray(polynomial(4)) .* (fractalParts(X)) .* (fractalParts(X));
    
    % Get closer to the actual formaula
    Pbilin (:, :, indexInput) = cast(Jgray, class(Igray));
    
end

Pbilin; % Completed Bilinear Interpolation (?) 

% -------------------------------------------------------------------------
% CUSTOM BILINEAR END !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!






%% Task-2

%{
Apply both the sobel and canny edge detectors to the image and display
the for comparison.


%}



% CAN TASK 2 FILTRATION BE USED HERE? PERHAPS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% 2-1a: Application of Sobel and Canny filters
BW1 = edge(Ibili, 'sobel');


%----------- START: CUSTOM SOBEL OPERATOR -----------

% Remember tic and toc

% Change all comments

% remove plus 1?
% K for Kernal? Try to find the atual term
% F for Filter? Followed by G?
Ax = [+1 0 -1; +2 0 -2; +1 0 -1]; % Moves Right
Ay = [-1 -2 -1; 0 0 0; +1 +2 +1]; % Moves Down (Check both)

B = img;
%{
By using:

[m, n] = size(A)

Am I creating another template, as well as the image?
Check notes for the method.

Also, what does rot90 do? Some kind of inverse?
Rotating the Mask perhaps?

Varying filters and 'edge' explained

%}

% Remember to highlight the convolutional step


Gx = conv2(img(:, :, 2), Fx, 'same');
Gy = conv2(img(:, :, 2), Fy, 'same'); % what is same?
% Try with conv2 and without (2D Convolution = conv2)

% Alt convolusion

for j = 1 : size(img, 1) -2
    for k = 1: size(img, 2) -2
        
        % Approximations of the Gradient
        p = sum(sum(Ax .* B(j : j + 2, k : k + 2))); % Should this not be + 1, instead of + 2?
        q = sum(sum(Ay .* B(j : j + 2, k : k + 2))); % Is this one of the PARAMETERS?
        % The above represents the algorithm for 2D convolusion in MATLAB
        
        Gx = p;
        Gy = q;
        
        C(j+1, k+1) = sqrt(Gx .* Gx + Gy .* Gy); % Gradient Magnitude
    end
end



% IMPORTANT: It would ALSO be good to show the X and Y direction in
% different subplots for the final output.
% THEN show the combined gradient magnitude.




% Have blocks of code which show incremental improvements.
% Compare them in subplots.


% Now to find the square root
% This would be the actual formula for Sobel Operators
G = sqrt(Gx .* Gx + Gy .* Gy); % This give the GRADIENT magnitude 
% How many ways can this be done? Changing sqrt for example

% Is dx the first order derivative?



% Parameter: Defining the threshold
% Binarize using the same method as Task 1.


% It may be appropriate to use dx here with (normalisation)?

% Is noamlisation another way to produce a binary image?
% Is it neccessary for the image to be binarised?




% use tic and toc to measure the time and performance


%----------- START: CUSTOM CANNY OPERATOR -----------

BW2 = edge(Ibili, 'canny');


% Step 1: Apply Gaussian Blur / Averaging Filter.

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
        % Also, manually calculate the mean, do not use a keyword.
        avgFilt (i, j) = mean(filter(:));
    end
end

% Step 2: Finding the gradient
% Similar to Sobel?







%----------------------------------------------------

% Step-2: Completion of Task-2
figure;

subplot (2, 2, 1), imshow(BW1), title('Task 2.a: Sobel Edge Detection');
subplot (2, 2, 2), imshow(BW2), title('Task 2.b: Canny Edge Detection');

% 2-2a. [J, rect] = imcrop(BW1);
cropBW1 = imcrop (BW1 , [742.5 577.5 803 835]); %used the imcrop feature to select the range of pixels
subplot (2, 2, 3), imshow (cropBW1), title ('Task 2.c: Sobel Close-Up')

% 2-2b. [J, rect] = imcrop(BW2);
cropBW2 = imcrop (BW2 , [742.5 577.5 803 835]); %used the imcrop feature to select the range of pixels
subplot (2, 2, 4), imshow (cropBW2), title ('Task 2.d: Canny Close-Up')

%% Task-3

%{
See the previously completed image. I believe a mixture of both are used.
The image should be segmented as well as possible 
%}

% Step 1: Read image, Convert to Grayscale and Add Padding

% s = regionprops(BW,I,{'Centroid', 'PixelValues', 'BoundingBox'});

BW2 = bwareafilt(Ibin,[12500 31000]);

%{
For my reference (From the Mathworks website):

'Eccentricity' — Scalar that specifies the eccentricity of the ellipse that has the same second-moments as the region. 
The eccentricity is the ratio of the distance between the foci of the ellipse and its major axis length. The value is between 0 and 1. 
(0 and 1 are degenerate cases; an ellipse whose eccentricity is 0 is actually a circle, while an ellipse whose eccentricity is 1 is a line segment.) 
This property is supported only for 2-D input label matrices.
%}

% Step 4: Output showing the processing of the image (GENERAL)

figure;

subplot ( 1 , 2 , 1 ) , imshow ( Ibin ) , title ( 'Step 3: Binarization of Filtered Image' ); 
subplot ( 1 , 2 , 2 ) , imshow ( BW2 ) , title ( 'Step 4: Components with an eccentricity > 0.70' ); 


% Step-5: Completion of Task-3

%% ---------------------------------------------------------------
%% ---------------------------------------------------------------
%% -------- USE THIS FOR TASK 1 --------

scale = [3 3]; %resolution scale factors: [rows columns]
% I (Input Image) by its original size
% I: R * C
oldSize = size (Igray);
% J (Output Image) the (N*N) block where the new image will be spread out
% J: R' * C'

% NOTE: Nearest Neighbour = Pixel Replication (Not interpolation)

% Take the old input and scale R and C to the variable newSize
newSize = max (floor (scale.* oldSize(1 : 2)), 1);

%Resize both the rows and columns to output, new, rescaled values.
rowIndex = min (round (((1 : newSize (1)) -0.5) ./ scale (1) + 0.5) , oldSize (1)); 
colIndex = min (round (((1 : newSize (2)) -0.5) ./ scale (2) + 0.5) , oldSize (2));


%{

REFERENCES

% REF: https://uk.mathworks.com/help/matlab/ref/rgb2gray.html
% REF: https://uk.mathworks.com/matlabcentral/answers/159282-convert-from-rgb-to-grayscale-without-rgb2gray

% https://uk.mathworks.com/matlabcentral/answers/479875-2d-convolution-sobel-filter-what-is-wrong
% Compare to some of the output in the lecture slides.

https://uk.mathworks.com/help/images/ref/edge.html
% https://uk.mathworks.com/help/matlab/ref/conv2.html#bvgtfpe

% https://www.imageeprocessing.com/2013/07/sobel-edge-detection-part-2.html

REF: https://uk.mathworks.com/help/images/edge-detection.html

%}
