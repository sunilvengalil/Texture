clear all;
clc;
indices1 = [3,10,50,40,70];
indices2 = [10,20,30,40,60];
bandedDir = 'C:\DTD\data\dtd\images\banded';
scalyDir = 'C:\DTD\data\dtd\images\scaly';
bandedFiles = dir(bandedDir);
scalyFiles = dir(scalyDir);


for bandedIndex = 1:length(indices1);
    for scalyIndex = 1:length(indices2);
        im1 = imread(strcat(bandedDir,'\',bandedFiles(indices1(bandedIndex) ).name));
        im2 = imread(strcat(scalyDir,'\',scalyFiles(indices2(scalyIndex) ).name));
        
        [p,n,e] = fileparts(bandedFiles(indices1(bandedIndex) ).name);
        [p1,n1,e1] = fileparts(scalyFiles(indices1(scalyIndex) ).name);
        outfileName = strcat(n,'_',n1,e);
        
        height = min(size(im1,1),size(im2,1) );
        width = min(size(im1,2),size(im2,2) );
        
        
        imwrite([im1(1:height,1:width);im2(1:height,1:width)],strcat('C:\DTD\Segmentation\',outfileName) );
    end
    
end



