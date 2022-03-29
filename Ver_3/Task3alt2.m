I = imread('Starfish.jpg');
I = rgb2gray(I);
I = medfilt2(I);
%E = entropyfilt(I);
subplot(2,3,1), imshow(I);

[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
BWs = edge(I,'sobel', threshold * fudgeFactor);
subplot(2,3,2), imshow(BWs), title('binary gradient mask');

se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);

BWsdil = imdilate(BWs, [se90 se0]);
subplot(2,3,3), imshow(BWsdil), title('dilated gradient mask');

BWdfill = imfill(BWsdil, 'holes');
subplot(2,3,4), imshow(BWdfill), title('binary image with filled holes');

BWnobord = imclearborder(BWdfill, 4);
subplot(2,3,5), imshow(BWnobord), title('cleared border image');

seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
subplot(2,3,6), imshow(BWfinal), title('segmented image');

