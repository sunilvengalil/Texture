%Plot sigma vs Following parameters
% variance, mean, min and max of filter response


%Plot Minimum, Maximum and Variance of filter response as a function of
%Filter orientation

%TODO - 1. x axis change the label to sigma instead of indices
%       2. plot only one filter response or all based on parameter


legendtype = ['r.';'g-';'b^';'ko';'c+';'m:';'bs';'kd'];
legendtypestr = cellstr(legendtype);

% Generate an array of string with legends
 deltaOrient = 180/numOrient;
 legendstr =  'Horizontal';
 lengthOfLegend = length(legendstr);
 
 for orient = 1 : numOrient
     leg = num2str(180 -orient*deltaOrient);
     leg = [leg blanks(lengthOfLegend - length(leg))];
     legendstr = [legendstr;leg];
 end
 
 

outputFolder = 'C:\TextonCode\SingleTexture\output\';
FileNamePrefix ='FilterResponseVsSigma';
outputFileName = strcat(outputFolder,FileNamePrefix,'_',fileName);

numberOfFilter = numOrient * 2 * numScales; % even and odd filter at each orientation
numberOfSigma = numScales;

%dimension -(orientation,sigma,odd/even)
maxFilterResponse = zeros(numOrient,numberOfSigma,2);
minFilterResponse = zeros(numOrient,numberOfSigma,2);
meanFilterResponse = zeros(numOrient,numberOfSigma,2);
varFilterResponse = zeros(numOrient,numberOfSigma,2);
oneSidedVarFilterResponse = zeros(numOrient,numberOfSigma,2);
absMeanFilterResponse = zeros(numOrient,numberOfSigma,2);


[height,width] = size( fim{1,1} ); %heigt,width used for reshaping

%create a vector with sigma values
sigmas = zeros(numberOfSigma,1);
for sigma = 1:numberOfSigma
    sigmas(sigma,1) = startSigma * scalingFactor ^ (sigma - 1)  ;
end


%get the filter statistitics index dimensioon (orientation, sigma, odd/even)


for sigma = 1:numberOfSigma
    for orient = 1 :numOrient;
            %compute statistics for odd and even filter response
            reshapedResponseOddFilter = reshape(fim{ orient *2,sigma}, height * width,1);
            reshapedResponseEvenFilter = reshape(fim{ orient *2 - 1,sigma}, height * width,1); %Odd numbered filteres are even symmetric fix this in orginal code
            
            maxFilterResponse(orient,sigma,1) = max(max(fim{orient * 2,sigma}));
            maxFilterResponse(orient,sigma,2) = max(max(fim{orient * 2 -1,sigma}));
            minFilterResponse(orient,sigma,1) = min(min(abs(fim{orient * 2,sigma}) ));
            minFilterResponse(orient,sigma,2) = min(min(abs(fim{orient * 2 - 1,sigma}) ));
            
            absMeanFilterResponse(orient,sigma,1) = mean( abs(reshapedResponseOddFilter) );
            absMeanFilterResponse(orient,sigma,2) = mean( abs(reshapedResponseEvenFilter) );
            
            meanFilterResponse(orient,sigma,1) = mean( (reshapedResponseOddFilter) );
            meanFilterResponse(orient,sigma,2) = mean( ( reshapedResponseEvenFilter ) );
            
            oneSidedVarFilterResponse(orient,sigma,1) = var(abs(reshapedResponseOddFilter));
            oneSidedVarFilterResponse(orient,sigma,2) = var(abs(reshapedResponseEvenFilter));
            varFilterResponse(orient,sigma,1) = var(reshapedResponseOddFilter);
            varFilterResponse(orient,sigma,2) = var(reshapedResponseEvenFilter);
    end
end

%plot

 varianceFig = figure;
 
 for orient=1:numOrient
    plot(sigmas,varFilterResponse(orient,:,1),legendtypestr{orient});
    hold on 
 end
 title('Variance of Response of each Filter');
 xlabel('Sigma');ylabel('Response of Filter');
 
 legend(legendstr);

 meanFig = figure;
 for orient = 1:numOrient
    plot(sigmas,maxFilterResponse(orient,:,1),legendtypestr{orient});
    hold on 
 end
 %title('Mean Absolute value of response of  Odd Filter with diffrent orientation ploted against sigma');
 xlabel('Sigma');ylabel('Response of Filter');
 
 %TODO correct the legend
 legend(legendstr);
 
%  hold on
%  plot(sigmas,maxFilterResponse(1,:)+ maxFilterResponse(2,:) + maxFilterResponse(2,:)+ maxFilterResponse(4,:) + maxFilterResponse(5,:) + maxFilterResponse(6,:),'g');
%  
%plot(maxFilterResponse','b');title('Maximum Response of each Filter');xlabel('Sigma');ylabel('Response of Filter');
%plot(varFilterResponse','b');title('Variance of  Response of each Filter');xlabel('Sigma');ylabel('Variance of Response of Filter');
% hold on;
%plot(minFilterResponse','r');title('Minimum Response of each Filter');xlabel('Sigma');ylabel('Response of Filter');

%write the  plot to file fig and jpg 

%saveas(varianceFig,strcat(outputFileName,'_variance'),'fig');
%saveas(varianceFig,strcat(outputFileName,'_variance'),'jpg');
% 
% 
%saveas(meanFig,strcat(outputFileName,'_mean'),'fig');
%saveas(meanFig,strcat(outputFileName,'_mean'),'jpg');
