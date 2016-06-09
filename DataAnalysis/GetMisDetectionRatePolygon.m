
imageWidth = 500;
imageHeight = 500;
im = ones(imageWidth,imageHeight);
texelwidth = 8;
texelheight = 8;

%polygon definition
xv=[100,300,120,320];
yv=[150,150,400,400];

numberOfTexels = 3300;
numberOfpointsAdded = 0;

numberOf1InsidePolygon = 0;
numberOf2InsidePolygon = 0;
numberOf1OutsidePolygon = 0;
numberOf2OutsidePolygon = 0;
for i = 1:500
    for j = 1:500
        if inpolygon(i,j,xv,yv) == 1
            if tmap(i,j)== 1
                numberOf1InsidePolygon = numberOf1InsidePolygon + 1;
            else
                numberOf2InsidePolygon = numberOf2InsidePolygon + 1;
            end
            
        else
            %Outsidepolygon
            if tmap(i,j)== 1
                numberOf1OutsidePolygon = numberOf1OutsidePolygon + 1;
            else
                numberOf2OutsidePolygon = numberOf2OutsidePolygon + 1;
            end
            
        end
        
    end
end

%reg1 is inside polygon
reg1Maj = 1;
if numberOf2InsidePolygon > numberOf1InsidePolygon
    reg1Maj = 2;
end


%reg2 is outside polygon
reg2Maj =1;
if reg1Maj == 1 
    reg2Maj = 2;
end

if reg1Maj == 1

    detectionRateInside  = numberOf2InsidePolygon/(numberOf1InsidePolygon + numberOf2InsidePolygon)
    detectionRateOutside = numberOf1OutsidePolygon/(numberOf1OutsidePolygon + numberOf2OutsidePolygon)
else
    detectionRateInside  = numberOf1InsidePolygon/(numberOf1InsidePolygon + numberOf2InsidePolygon)
    detectionRateOutside = numberOf2OutsidePolygon/(numberOf1OutsidePolygon + numberOf2OutsidePolygon)
end




%imwrite(im,fileName,'jpg');


%imshow(im);
            