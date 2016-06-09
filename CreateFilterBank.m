clear all
close all

%parameters
sigmayStart = 0.7;
numOrient = 6;
% try with 1, 3 and 6
numScales = 1;
%scalingFactor = 1.4;
scalingFactor =1.1832;
elongationstart = 3;
ntex = 2;
numscalesForSearch = 7;
numElongations = 10;

folderName = 'C:\DTD\segmentation\';
outfolderName = strcat(folderName,'output\');



files = dir(strcat(folderName,'*.jpg'));

scales =1; sigmay= 1.6233;elongation = 3;
fb = fbCreate(numOrient,sigmay,numScales,scalingFactor,elongation);
