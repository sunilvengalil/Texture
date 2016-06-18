function [ features ] = GetFilterFeatures( im )
%Convert the image into texton assuming image is composed of single 
% Texture
%   Detailed explanation goes here
%parameters
%

sigmay = 2;
numOrient = 6;
% try with 1, 3 and 6
numScales = 3;
scalingFactor = 1.4;
elongation = 3;


if(size(im,3) ~= 1)
    ima = rgb2gray(im);
else
    ima = im;
end


if(size(ima,1) > 800 || size(ima,2) > 800)
    f = 800/ max(size(ima,1),size(ima,2));
    ima = imresize(ima,f);
end
ima = double(ima) /255;


% pass the filter bank as argument
fb = fbCreate(numOrient,sigmay,numScales,scalingFactor,elongation);

fim = fbRun(fb,ima);

d = numel(fim);
n = numel(fim{1});
data = zeros(d,n);
for i = 1:d,
  data(i,:) = abs(fim{i}(:))';
end


features.descr = data;
end

