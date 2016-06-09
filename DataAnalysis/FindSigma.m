
clear all
close all
%im = imgRead(106020,'gray');

% fileName ='C:\TextonCode\SingleTexture\RandomSpacing45DegreeLine1300Texel.jpg';
folderName = 'C:\TextonCode\SingleTexture\';
%fileName ='RandomSpacing45Line1300Texel';
%fileName = 'RandomSpacing0DegreeLine1300Texel'
%fileName ='RandomSpacing45And0DegreeLine1300TexelInverted'
fileName ='RandomSpacing45And0DegreeLine1300Texel'
%fileName = 'RandomSpacing45And0DegreeLine1300Texel'
im = imread( strcat(folderName, fileName, '.jpg') );

if(size(im,3) ~= 1)
    im = rgb2gray(im);
end

size(im)
if(size(im,1) > 1200 || size(im,2) > 1200)
     im = imresize(im,0.5);
end

size(im)
im = double(im) /255;

%parameters
startSigma = 0.1;
% TODO what should be in number of orientation initially - try with 30
% degree and 10 degree
numOrient = 4; 
% try with 1, 3 and 6
numScales = 3;
scalingFactor = 4;

%TODO what should be this value try with  a range and a set of images
elongation = 3;

fb = fbCreate(numOrient,startSigma,numScales,scalingFactor,elongation);
fim = fbRun(fb,im);


[idx,c] = getOrientations(numOrient,numScales,startSigma,scalingFactor,fim);




