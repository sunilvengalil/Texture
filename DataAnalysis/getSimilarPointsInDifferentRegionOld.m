
outputFolder = 'C:\TextonCode\SingleTexture\output\';
FileNamePrefix ='ComparisonOfPointsInDifferentRegionForSameTexton';
outputFileName = strcat(outputFolder,FileNamePrefix,'_',fileName);


%Take  windows of largest filter size in fb, centered at the 
%center of both the regions
[height, width] = size(im);
region1Center = [height/4,width/2]; %two regions are stacked veritically
region2Center = [3 * height/4,width/2]; %two regions are stacked veritically

% find the max filter size
maxsz = max(size(fb{1}));
for i = 1:numel(fb),
  maxsz = max(maxsz,max(size(fb{i})));
end

%get all points of cluster 1 centered at region1Center
%rectangular window centered at region1
top = region1Center(1)  - maxsz;
bottom = region1Center(1) + maxsz;
left = region1Center(2)  - maxsz;
right = region1Center(2) + maxsz;

%show the window in tmap
tmapWithRegion = tmap;
tmapWithRegion(top,left:right) = 50;
tmapWithRegion(bottom,left:right) = 50;
tmapWithRegion(top:bottom,left) = 50;
tmapWithRegion(top:bottom,right) = 50;
%imshow(tmapWithRegion,[]);

%rectangular window centered at region2
top2 = region2Center(1)  - maxsz;
bottom2 = region2Center(1) + maxsz;
left2 = region2Center(2)  - maxsz;
right2 = region2Center(2) + maxsz;

%show the window in tmap
tmapWithRegion(bottom2,left2:right2) = 3;
tmapWithRegion(top2,left2:right2) = 3;
tmapWithRegion(top2:bottom2,right2) = 3;
tmapWithRegion(top2:bottom2,left2) = 3;
%imshow(tmapWithRegion,[]);

region1 = tmap(top:bottom,left:right);

d = size(tex, 1);
numberOfTexton = size(tex,2);
textonIndex = 1;
z = region1 ==  textonIndex;
%Todo any other ways of doing this better ?
n = sum(sum(z));

data = zeros(d,n);
[height,width] = size(tmap);
minDistance = 10000;
minx = 0;miny=0;
minIndex = 0;
for i = 1:d
        nindex =1;
        for x = top : bottom;
             for y = left : right;
                 if ( tmap(x,y) == textonIndex)
                    data(i,nindex) =  fim{i}(x,y);
                    dist = norm( data(:,nindex) - tex(:,textonIndex) );
                    if(dist < minDistance)
                        minDistance = dist;
                        minx = x; miny = y;
                        minIndex = nindex;
                    end
                    
                    
                    nindex = nindex + 1;
                 end
             end
        end
end


region2 = tmap(top2:bottom2,left2:right2);
z = region2 ==  textonIndex;
%Todo any other ways of doing this better ?
n = sum(sum(z));
nindex2 = 1;
data2 = zeros(d,n);

minDistance2 = 10000;
minx2 = 0;miny2=0;
minIndex2 = 1;

for i = 1:d
        nindex =1;
        for x = top2 : bottom2;
             for y = left2 : right2;
                 if ( tmap(x,y) == textonIndex)
                    data2(i,nindex) =  fim{i}(x,y);
                    
                    dist = norm( data2(:,nindex) - tex(:,textonIndex) );
                    if(dist < minDistance2)
                        minDistance2 = dist;
                        minx2 = x; miny2 = y;
                        minIndex2 = nindex;
                    end
                    
                    nindex = nindex + 1;
                 end
             end
        end
end

img = cell(2);
filterSize = floor(size(fb{1},1)/2);

%img{1}=im(minx-filterSize:minx+filterSize,miny-filterSize:miny+filterSize);
%img{2}=im(minx2-filterSize:minx2+filterSize,miny2-filterSize:miny2+filterSize);

textonfig = figure;

%plot(data(:,minIndex),'+')
%hold on
%plot(data(:,minIndex2),'*')
%hold on
plot(tex(:,1),'r')
hold on
plot(tex(:,2),'b')
legend('texton 1', 'texton 2','Location','SouthEast');
title('Cluster cetnroids with two clusters');
xlabel('Filter number');ylabel('Filter Response');


imagePatchfig = figure;
%subplot(2,1,1);imshow(img{1},[]);title('Region 1');
%subplot(2,1,2);imshow(img{2},[]);title('Region 1');


 saveas(textonfig,strcat(outputFileName,'_responsePlotAbs'),'fig');
 saveas(textonfig,strcat(outputFileName,'_responsePlotAbs'),'jpg');
% 
% saveas(imagePatchfig,strcat(outputFileName,'_imagePatch'),'fig');
% saveas(imagePatchfig,strcat(outputFileName,'_imagePatch'),'jpg');
% 

