function [ confusionMatrix ] = GetConfusionMatrix(ntex, tmap,refImage)

% first index for each region, second index for each label in that region
[h,w] = size(tmap);
numberOfLabels = zeros(ntex,ntex);
% ones detected as  ones 
indices = refImage == 1 ;
numberOfLabels(1,1) = sum( tmap(indices) );
% ones detected as  zeros
numberOfLabels(1,2) = length(tmap(indices)) - numberOfLabels(1,1);

%zeros detected as ones
indices = refImage == 0 ;
numberOfLabels(2,1) = sum( tmap(indices) );
numberOfLabels(2,2) = length(tmap(indices)) - numberOfLabels(1,1);


confusionMatrix = numberOfLabels;
confusionMatrix = confusionMatrix ./ ( h * w );

%T = table(numberOfLabels(:,1),numberOfLabels(:,2),'RowNames',regionLabels);
            

end

