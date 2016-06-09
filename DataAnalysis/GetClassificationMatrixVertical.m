function [ classificationMatrix ] = GetClassificationMatrixVertical( ntex, tmap,imageHeight,imageWidth )
    %imageWidth = 400;
    %imageHeight = 800;

    %majority labels in each region
    region = ones(ntex);
    % first index for each region, second index for each label in that region
    numberOfLabels = zeros(ntex,ntex);

    %Segment top and bootom region
    middle = size(tmap,1)/2;
    topregion = zeros(middle,size(tmap,2 ) );
    topregion = tmap(1:middle,:);
    
        
    bottomregion = tmap( middle + 1:imageHeight,:);
    
       
    numberOfLabels(1,1) = sum(sum(topregion == 1));
    numberOfLabels(1,2) = sum(sum(topregion == 2));
    numberOfLabels(2,1) = sum(sum(bottomregion == 1));
    numberOfLabels(2,2) = sum(sum(bottomregion == 2));

    sumv = sum(numberOfLabels,2);

    for i = 1: length(sumv)
        for j = 1 : ntex
            numberOfLabels(i,j ) = numberOfLabels(i,j)/sumv(i);
        end
    end
    
    classificationMatrix = numberOfLabels

end

