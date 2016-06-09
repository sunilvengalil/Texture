
filterNumber = 1;

outputFolder = 'C:\TextonCode\SingleTexture\output\';
outputFileName =strcat(outputFolder,'FilterMaskCrossSection',num2str(filterNumber) );

filterSizeByTwo = floor(size(fb{1},1)/2);

horzCrossSectionFig = figure;
plot(fb{filterNumber}(filterSizeByTwo,:));
title(strcat('FilterNumber ',num2str(filterNumber), strcat( '- Filter Mask values along row ',num2str(filterSizeByTwo) ) ) );

VertCrossSectionFig = figure;
plot(fb{filterNumber}(:,filterSizeByTwo));
title(strcat('FilterNumber ',num2str(filterNumber), strcat( '- Filter Mask values along column ',num2str(filterSizeByTwo) ) ));

% saveas(horzCrossSectionFig,strcat(outputFileName,'_horz'),'fig');
% saveas(horzCrossSectionFig,strcat(outputFileName,'_vert'),'jpg');
% 
% saveas(VertCrossSectionFig,strcat(outputFileName,'_horz'),'fig');
% saveas(VertCrossSectionFig,strcat(outputFileName,'_vert'),'jpg');

