% MATLAB script for Assessment Item-1
% Task-1
clear; close all; clc;


%% -------- Step 1: Load Input Image --------

I = imread ( 'C:\Users\Jason Laptop\Downloads\Ass1 MATLAB\Ass1 MATLAB\Assignment_Input\Zebra.jpg' );
J = imread ( 'C:\Users\Jason Laptop\Downloads\Ass1 MATLAB\Ass1 MATLAB\Assignment_Input\Zebra.jpg' );
figure;
subplot ( 2 , 2 , 1 ) , imshow(I), title('Step-1: Load input image');


%% -------- Step 2: Convert Input Image to Grayscale --------

Igray = rgb2gray ( I );
Igray2 = rgb2gray ( J );

size(Igray)
size(Igray2)

subplot ( 2 , 2 , 2 ) , imshow(Igray), title('Step-2: Conversion of input image to greyscale');


%% -------- Step 3: Nearest Neighbour Interpolation --------

scale = [ 0.5 0.5 ]; %resolution scale factors: [rows columns]
% I (Input Image) by its original size
% I: R * C
oldSize = size ( Igray );
% J (Output Image) the (N*N) block where the new image will be spread out
% J: R' * C'
% -----------------

% NOTE: Nearest Neighbour = Pixel Replication (Not interpolation)

% Take the old input and scale R and C to the variable newSize
newSize = max ( floor ( scale .* oldSize( 1 : 2 ) ) , 1 );

%Resize both the rows and columns to output, new, rescaled values.
rowIndex = min ( round ( ( ( 1 : newSize ( 1 ) ) -0.5 ) ./ scale ( 1 ) + 0.5 ) , oldSize ( 1 ) ); 
colIndex = min ( round ( ( ( 1 : newSize ( 2 ) ) -0.5 ) ./ scale ( 2 ) + 0.5 ) , oldSize ( 2 ) );

size(rowIndex)
size(colIndex)

Nearest = Igray ( rowIndex , colIndex , : );
subplot ( 2 , 2 , 3 ) , imshow ( Nearest ) , title('Step-3: Nearest Neighbour Interpolation')


%% -------- Step 4: Bilinear Interpolation  --------

% Call the Task1Func (Bilinear Interpolation) function
Bilinear = Task1Func ( Igray , [ 278 306 ] ); % Specify the size of the interpolated output (In Grayscale)
subplot ( 2 , 2 , 4 ) , imshow ( Bilinear ) , title ( 'Step-4: Bilinear Interpolation ' )

[m, n] = size(Nearest);

% Method 2

BilinearNN = Task1Func ( Igray , [ m n ] ); % Specify the size of the interpolated output (In Grayscale)

% Method 3

[M, N] = size(Igray2);

r = M / 2;
c = N / 2;

size(r)
size(c)

BilinearCR2 = Task1Func ( Igray2 , [ r c ] ); % Specify the size of the interpolated output (In Grayscale)

% Output

size(Bilinear)
size(BilinearNN)
size(BilinearCR2)

figure;
subplot ( 1 , 3 , 1 ) , imshow ( Bilinear ) , title ( 'Step-X: Bilinear Interpolation PRE NN' )
subplot ( 1 , 3 , 2 ) , imshow ( BilinearNN ) , title ( 'Step-Y: Bilinear Interpolation POST NN ' )
subplot ( 1 , 3 , 3 ) , imshow ( BilinearCR2 ) , title ( 'Step-Y: Bilinear Interpolation POST CR / 2' )

%% -------- Step-5: Crop the Filtered Images --------

figure;

%[J, rect] = imcrop(outputImage);
cropNN = imcrop ( Nearest , [ 300 430 200 200 ] ); %used the imcrop feature to select the range of pixels
subplot ( 1 , 2 , 1 ) , imshow ( cropNN ) , title ( 'Step-5.i: Crop and Zoom of Nearest Neighbour Interpolation' , 'FontSize' , 18 )

%[J, rect] = imcrop(out);
cropBI = imcrop ( Bilinear , [ 300 430 200 200 ] ); %used the imcrop feature to select the range of pixels
subplot ( 1 , 2 , 2 ) , imshow ( cropBI ) , title ( 'Step-5.ii: Crop and Zoom of Bilinear Interpolation' , 'FontSize' , 18 )
