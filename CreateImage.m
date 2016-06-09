im1 = imread('C:\DTD\data\dtd\images\banded\banded_0008.jpg');
im2 = imread('C:\DTD\data\dtd\images\scaly\scaly_0131.jpg');

imshow([im1;im2]);
imwrite([im1;im2],'C:\DTD\Segmentation\banded_0008_scaly_0131.jpg');


