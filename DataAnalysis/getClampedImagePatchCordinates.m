function [ xfrom, xto, yfrom, yto ] = getClampedImagePatchCordinates( xIndex,yIndex,filterSize,imageSize )
    x = imageSize(1);
    y = imageSize(2);
    yfrom = yIndex-filterSize;
    if(yfrom < 1)
        yfrom = 1;
    end

    yto =   yIndex+filterSize;
    if(yto > y)
        yto = y;
    end

    xfrom = xIndex-filterSize;
    if(xfrom < 1)
        xfrom = 1;
    end

    xto = xIndex+filterSize;
    if(xto > x)
        xto = x;
    end

end

