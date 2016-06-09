function [ idx, c ] = getOrientations( numOrient,numScales,startSigma,scalingFactor,fim )

%Get Dominant orientations for the image by looking at the mean 
% variance, mean, min and max of filter response

%Plot Minimum, Maximum and Variance of filter response as a function of
%Filter orientation

%TODO - 1. x axis change the label to sigma instead of indices
%       2. plot only one filter response or all based on parameter


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

for sigma = 1:numberOfSigma
    for orient = 1 :numOrient;
            %compute statistics for odd and even filter response
            reshapedResponse = reshape(fim{ orient *2,sigma}, height * width,1);
            reshapedResponseEven = reshape(fim{ orient *2 - 1,sigma}, height * width,1); %Odd numbered filteres are even symmetric fix this in orginal code
            
            maxFilterResponse(orient,sigma,1) = max(max(fim{orient * 2,sigma}));
            maxFilterResponse(orient,sigma,2) = max(max(fim{orient * 2 -1,sigma}));
            minFilterResponse(orient,sigma,1) = min(min(abs(fim{orient * 2,sigma}) ));
            minFilterResponse(orient,sigma,2) = min(min(abs(fim{orient * 2 - 1,sigma}) ));
            
            absMeanFilterResponse(orient,sigma,1) = mean( abs(reshapedResponse) );
            absMeanFilterResponse(orient,sigma,2) = mean( abs(reshapedResponseEven) );
            
            meanFilterResponse(orient,sigma,1) = mean( (reshapedResponse) );
            meanFilterResponse(orient,sigma,2) = mean( ( reshapedResponseEven ) );
            
            oneSidedVarFilterResponse(orient,sigma,1) = var(abs(reshapedResponse));
            oneSidedVarFilterResponse(orient,sigma,2) = var(abs(reshapedResponseEven));
            varFilterResponse(orient,sigma,1) = var(reshapedResponse);
            varFilterResponse(orient,sigma,2) = var(reshapedResponseEven);
    end
end



%plot

 varianceFig = figure;
 
 plot(sigmas,varFilterResponse(1,:,1),'r');
 hold on 
 plot(sigmas,varFilterResponse(2,:,1),'g');
 hold on;
 plot(sigmas,varFilterResponse(3,:,1),'b');
 hold on 
 plot(sigmas,varFilterResponse(4,:,1),'y');
 title('Variance of Response of each Filter');xlabel('Sigma');ylabel('Response of Filter');
 legend('Horizontal','135 degree','Vertical','45 degree');

 meanFig = figure;
 
 plot(sigmas,absMeanFilterResponse(1,:,1),'r');
 hold on 
 plot(sigmas,absMeanFilterResponse(2,:,1),'g');
 hold on;
 plot(sigmas,absMeanFilterResponse(3,:,1),'b');
 hold on 
 plot(sigmas,absMeanFilterResponse(4,:,1),'y');
 title('Mean Response of each Filter Odd');xlabel('Sigma');ylabel('Response of Filter');
 legend('Horizontal','135 degree','Vertical','45 degree');
 
   
%  hold on
 % plot(sigmas,maxFilterResponse(1,:)+ maxFilterResponse(2,:) + maxFilterResponse(2,:)+ maxFilterResponse(4,:) + maxFilterResponse(5,:) + maxFilterResponse(6,:),'g');
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

 x = zeros(4,numberOfSigma);
 x(1,:) = absMeanFilterResponse(1,:,1);
 x(2,:) = absMeanFilterResponse(2,:,1);
 x(3,:) = absMeanFilterResponse(3,:,1);
 x(4,:) = absMeanFilterResponse(4,:,1);
  
 [idx,c] =kmeans(x,2);
 
 
 
 
 
end

