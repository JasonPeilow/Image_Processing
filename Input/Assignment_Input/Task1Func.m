function [ bilinOutput ] = Task1Func ( input , transOut )
% Referenced this tutorial: https://ia802707.us.archive.org/23/items/Lectures_on_Image_Processing/EECE_4353_15_Resampling.pdf
% REF PROPERLY 10/06/2020

% Index rows are of I or 'input' (zebra.jpg)

indexRows = size ( input , 1 ); % Rows of the input image.
indexCols = size ( input , 2 ); % Columns of the input image.
transRows = transOut ( 1 ); % Rows of the output/transformed image.
transCols = transOut ( 2 ); % Columns of the output/transformed image.
   
    
%% -------- Step 4.i: Scalar for Rows and Columns --------

% Calculating Scale Factors - First Part
scaleR = indexRows / transRows; % sR = R/R' (Scale Factor of Rows)
scaleC = indexCols / transCols; % sC = C/C' (Scale Factor of Columns)

% Essentially, rf = [1,....R'], cf = [(1,....C').sC]]
% The fractional location of the input image is fitted to the output grid
[ fractC, fractR ] = meshgrid ( 1 : transCols , 1 : transRows ); % meshgrid returns a two dimensional array.

    
%% -------- Step 4.ii: Fractal Rows and Columns --------

% Establishing Integers - First Part:
% Multiplying the fractal location by scale
% This gives a new value for every I (input) in pixel J (output)
fractR = fractR * scaleR; 
fractC = fractC * scaleC;  


%% -------- Step 4.iii: Fractal Rows and Columns --------

% Establishing Integers - Second Part:
% Floor of rf and cf (almost self explanatory in MATLAB).
zeroR = floor ( fractR ); % This gives the ROW INDICES
zeroC = floor ( fractC ); % This gives the COLUM INDICES
% Floor tound the Fractal Row to the nearest less than equal element
% or the largest integer less that equal to X
    

%% -------- Step 4.iv: Calculation of Scalars --------

% Calculating Scale Factors - Second Part
zeroR ( zeroR < 1 ) = 1; 
zeroC ( zeroC < 1 ) = 1; 
zeroR ( zeroR > indexRows - 1 ) = indexRows - 1; 
zeroC ( zeroC > indexCols - 1 ) = indexCols - 1; 

% These are the integer parts of (rF and cF or fractR and fractC)
% This gives deltaR and deltaC
% These are the fractional parts of the ROW and COLUMN locations
deltaR = fractR - zeroR; 
deltaC = fractC - zeroC;

    
%% -------- Step 4.v: Building the Structure --------
        
% Every output pixel of J (output image)
% Final prepaeration of the algorithm.
% EXPLAINED: 
% Every Row and Column Integer is treated as a marker for every point we
% wish to access and each of these lines of code represents the
% representation of the bilinear interpolation model.
% It is also important to note that indexRows and indexColums are the base
% template for this application...
topLeft = sub2ind ( [ indexRows , indexCols ] , zeroR , zeroC ); %... r0, c0 (top left)
botLeft = sub2ind ( [ indexRows , indexCols ] , zeroR + 1 , zeroC ); %... r0+1, c0 (bottom left)
topRght = sub2ind ( [ indexRows , indexCols ] , zeroR , zeroC + 1 ); %... r0, c0+1 (top right)
botRght = sub2ind ( [ indexRows , indexCols ] , zeroR + 1 , zeroC + 1 ); %...r0+1, c0+1 (bottom right)  
%sub2ind allows for the subscript to linear indices


%% -------- Step 4.vi: Interpolation of the channels --------

bilinOutput = zeros ( transRows , transCols , size ( input , 3 ) ); % Fix the dimensions of the output image to a matrix of zeros.
bilinOutput = cast ( bilinOutput , class ( input ) ); % Cast variable to a different data type. Class determines the class of the object (input)

for idx = 1 : size ( input , 3 ) 
    I4J = double ( input ( : , : , idx ) ); % The input channel
    %Just follow the formula...
    BI = I4J ( topLeft ) .* ( 1 - deltaR ) .* ( 1 - deltaC ) + ...  % I(r0,c0).(1-deltaR).(1-deltaC)
         I4J ( botLeft ) .* ( deltaR ) .* ( 1 - deltaC ) + ...      %+I(r0+1,c0).(deltaR).(1-deltaC)
         I4J ( topRght ) .* ( 1 - deltaR ) .* ( deltaC ) + ...      %+I(r0,c0+1).(1-deltaR).deltaC
         I4J ( botRght ) .* ( deltaR ) .* ( deltaC );               %+I(r0+1,c0+1).deltaR.deltaC
    bilinOutput ( : , : , idx ) = cast ( BI , class ( input ) ); % output chosen rows and columns while indexing formula
end