function [ tex ] = FindTexton3( im )
%Convert the image into texton assuming image is composed of single 
% Texture
%   Detailed explanation goes here
%parameters
%

sigmay = 2.7;
numOrient = 6;
% try with 1, 3 and 6
numScales = 1;
scalingFactor = 1.4;
elongation = 3;

% im1 = imread( strcat(folderName,suffixedFileName) );
% if(size(im1,3) ~= 1)
%         im = rgb2gray(im1);
% else
%     im = im1;
% end
% 
% clear im1;
% 
% if(size(im,1) > 800 || size(im,2) > 800)
%     f = 800/ max(size(im,1),size(im,2));
%     im = imresize(im,f);
% end
% im = double(im) /255;

fb = fbCreate(numOrient,sigmay,numScales,scalingFactor,elongation);


fim = fbRun(fb,im);

tex = computeMean(fim);
end

