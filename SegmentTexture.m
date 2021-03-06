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

folderName = 'C:\DTD\segmentation\';
outfolderName = strcat(folderName,'output\');

suffixedFileName='banded_0008_scaly_0131';

errors= zeros(12,1);
errorsNorm = zeros(12,10);
idealResult = [1 0 ; 0 1];
idealResult1 = [0 1 ; 1 0];

sigmay = sigmayStart;
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

    elongationStep = 1;
%elongation = elongationstart;sigmay = sigmayStart;
scales =1; sigmay= 1.6233;elongation = 8;
elongations  = zeros(numElongations,numscalesForSearch);
sigmas = zeros(numElongations,numscalesForSearch);
%for scales = 1: numscalesForSearch
% for elongationStep = 1 :numElongations
    elongations(elongationStep,scales) = elongation;
    sigmas(elongationStep,scales) = sigmay;
    fb = fbCreate(numOrient,sigmay,numScales,scalingFactor,elongation);
    fim = fbRun(fb,im);
    [tmap,tex] = computeTextonsAbs(fim,ntex);

        %[tim,tperm] = visTextons(tex,fb);
        %texmapFig = figure;
        %imshow(tmap,[]);
        bintmap = tmap;
        bintmap(tmap == 2) = 0;
        %imshow(bintmap,[]);
    imwrite(bintmap,tmapfileName,'jpg');
    imwrite(im,preProcessedInputFileName,'jpg')

    classificationMatrix = GetClassificationMatrixVertical(ntex,tmap,height,width);
    errorsNorm(elongationStep,scales) = norm(classificationMatrix -  idealResult);
    if norm(classificationMatrix - idealResult1) < errorsNorm(elongationStep,1)
         errorsNorm(elongationStep,scales) = norm(classificationMatrix - idealResult1);
    end
    %clear fim
    %clear tmap;
    %clear suffixedFileName;
         %clear fb;
   % clear bintmap;
    %end
   %     clear im;

  elongation = elongation + 1;
 % end
 sigmay = sigmay * scalingFactor ;
 elongation = elongationstart;
%end

e = errorsNorm(1:numElongations,1:numscalesForSearch);
[v,ri] = min(e);
[v,ci] = min(v);
ri = ri(ci);

disp(strcat('Elongation: ',num2str(elongation  + ri -1)  ) );
disp(strcat('Sigmay:', num2str(sigmayStart * scalingFactor ^ (ci - 1))  ));
disp(classificationMatrix);
 %error
%saveas(texmapFig,tmapfileName,'jpg');
%  im(tmap ==2) = 0;
%  imshow(im,[]);