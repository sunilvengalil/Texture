function [ classificationMatrix ] = GetClassificationMatrix( ntex, tmap,xv,yv)

[imageHeight,imageWidth] = size(tmap);

% first index for each region, second index for each label in that region
numberOfLabels = zeros(ntex,ntex);

for i = 1:imageHeight
    for j = 1:imageWidth
        if inpolygon(i,j,xv,yv) == 1
            if tmap(i,j)== 1
                numberOfLabels(1,1) = numberOfLabels(1,1) + 1;
            else
                 numberOfLabels(1,2) = numberOfLabels(1,2) + 1;
            end
            
        else
            %Outsidepolygon
            if tmap(i,j)== 1
                numberOfLabels(2,1) = numberOfLabels(2,1) + 1;
            else
                numberOfLabels(2,2) = numberOfLabels(2,2) + 1;
            end
            
        end
        
    end
end

sumv = sum(numberOfLabels,2);

for i = 1: length(sumv)
    for j = 1 : ntex
        numberOfLabels(i,j ) = numberOfLabels(i,j)/sumv(i);
    end
end

classificationMatrix =numberOfLabels;

%T = table(numberOfLabels(:,1),numberOfLabels(:,2),'RowNames',regionLabels);
            

end

