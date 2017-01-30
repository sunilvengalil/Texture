clc;
clear all;
imfolderName = fullfile('C:\TextureDL\data\','sampleImages');
texelheight=10;texelwidth = 10; orientation1deg = 90;
orientation1rad = orientation1deg * (pi/180);
maxThickness = 3;
im = zeros(texelheight,texelwidth,maxThickness);
for thickness = 1 : maxThickness;

    im(:,:,thickness) = createTexel(texelheight,texelwidth,orientation1rad ,100,0,thickness);
end


%write images

vl_xmkdir(imfolderName);


 for thickness = 1:maxThickness
     subplot(1,maxThickness,thickness),imshow(im(:,:,thickness));
     filename =fullfile(imfolderName, strcat(int2str(thickness),'.png' ));
     imwrite(im(:,:,thickness),filename,'png','BitDepth',8);
 end
 
  imReloaded = zeros(texelheight,texelwidth,maxThickness);
  for thickness = 1:maxThickness
      %subplot(1,maxThickness,i),imshow(im(:,:,thickness));
      filename =fullfile(imfolderName, strcat(int2str(thickness),'.png' ) );
      imReloaded(:,:,thickness) = imread(filename,'png');
  end
  
  display(strcat('Difference between reloaded and original image',num2str( mean( (imReloaded - im ) .^2)) ) );
  
 
 