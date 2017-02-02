clc;
clear all;
imfolderName = fullfile('C:\TextureDL\data\','sampleImages');
texelheight=10;texelwidth = 10;
maxThickness = 3;
maxOrientation = 3;
if(maxOrientation > 1)
    step = 90/ (maxOrientation - 1 );
else
    step = 0;
end
    
im = zeros(texelheight,texelwidth,maxThickness,maxOrientation);
%creating images
for orientation = 1:maxOrientation
    orientationDeg = step * (orientation - 1); 
    orientationRad = orientationDeg * (pi/180);
    for thickness = 1 : maxThickness;
        im(:,:,thickness,orientation) = createTexel(texelheight,texelwidth,orientationRad ,100,0,thickness);
    end
end


%plot and write images to file

vl_xmkdir(imfolderName);
for orientation = 1:maxOrientation
     for thickness = 1:maxThickness
         linIndex = sub2ind([maxOrientation,maxThickness],orientation,thickness);
         subplot(maxOrientation,maxThickness,linIndex),imshow(im(:,:,thickness, orientation));
         title(strcat('o=',num2str(orientation),' t=',num2str(thickness)));
         filename =fullfile(imfolderName, strcat(int2str(linIndex),'.png' ));
         imwrite(im(:,:,thickness,orientation ),filename,'png','BitDepth',8);
     end
end
 
imReloaded = zeros(texelheight,texelwidth,maxThickness);

for orientation= 1:maxOrientation
      for thickness = 1:maxThickness
          %subplot(1,maxThickness,i),imshow(im(:,:,thickness));
          linIndex = sub2ind([maxOrientation,maxThickness],orientation,thickness);
          filename =fullfile(imfolderName, strcat(int2str(linIndex),'.png' ) );
          imReloaded(:,:,thickness,orientation) = imread(filename,'png');
      end
end

display(strcat('Difference between reloaded and original image',num2str( mean( (imReloaded - im ) .^2)) ) );
  
 
 