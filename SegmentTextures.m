% Author : Sunil Kumar Vengalil
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

folderName = 'C:\DTD\segmentation\dottedFibrous\';
outfolderName = strcat(folderName,'output\');
idealResult = [1 0; 0 1];
idealResult1 = [0 1; 1 0];
totalError = 0;

files = dir(strcat(folderName,'*.jpg'));

scales =1; sigmay= 1.6233;elongation = 1;

totalErrors = zeros (numElongations,1);
for elongationStep = 1:numElongations
   totalError = 0;
for fileIndex = 1: length(files)
    fb = fbCreate(numOrient,sigmay,numScales,scalingFactor,elongationStep);

    [p,n,e]= fileparts(files(fileIndex).name);
    suffixedFileName=n;
    tmapfileName = strcat(outfolderName, suffixedFileName,'_sigma',num2str(sigmay),'_numOrientation',num2str(numOrient),'_numScales',num2str(numScales),'_tmapabs','.jpg');
    preProcessedInputFileName = strcat(outfolderName,suffixedFileName,'_preprocessed','.jpg');

    if exist(preProcessedInputFileName, 'file')
        im1 = imread( strcat(preProcessedInputFileName) );
    else
        im1 = imread( strcat(strcat(folderName,suffixedFileName,'.jpg') ) );
    end
    
    if(size(im1,3) ~= 1)
            im = rgb2gray(im1);
    else
        im = im1;
    end

    clear im1;

    if(size(im,1) > 800 || size(im,2) > 800)
        f = 800/ max(size(im,1),size(im,2));
        im = imresize(im,f);
    end
    im = double(im) /255;
    [height,width] = size(im);

    fim = fbRun(fb,im);
    [tmap,tex] = computeTextonsAbs(fim,ntex);

    bintmap = tmap;
    bintmap(tmap == 2) = 0;
    imwrite(bintmap,tmapfileName,'jpg');
 %   imwrite(im,preProcessedInputFileName,'jpg')

    classificationMatrix = GetClassificationMatrixVertical(ntex,tmap,height,width);
    errorsNorm = norm(classificationMatrix -  idealResult);
    if norm(classificationMatrix - idealResult1) < errorsNorm
         errorsNorm = norm(classificationMatrix - idealResult1);
    end

    totalError = totalError + errorsNorm;
     
    clear fim
    clear tmap;
    clear suffixedFileName;
    clear bintmap;
    clear im;
end
totalErrors(elongationStep,1) = totalError;
end

