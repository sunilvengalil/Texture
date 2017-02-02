clc;
clear all;

texelheight=18;texelwidth = 18; orientation1deg = 0;
orientation1rad = orientation1deg * (pi/180);
   
%creating images
im = createTexel(texelheight,texelwidth,orientation1rad,100,0,1);


%plot and write images to file

imshow(im);
 
