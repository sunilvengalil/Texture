
Abs = 1;
filterNumber = 1;
if(Abs == 0 )
    outfilename='MaxMinImagePatch';
    fr = fim{filterNumber};
else
    outfilename = 'MaxMinImagePatchAbs'
    fr = abs(fim{filterNumber});
end;



filterSizeByTwo = floor(size(fb{1},1)/2);
[minvalue,minyIndex] = min(min(fr));
[minvalue,minxIndex] = min(fr(:,minyIndex));

[maxvalue,maxyIndex] = max(max(fr));
[maxvalue,maxxIndex] = max(fr(:,maxyIndex));

[xfrom,xto,yfrom,yto] = getClampedImagePatchCordinates(minxIndex,minyIndex, filterSizeByTwo,size(im));
imgmin = im(xfrom:xto,yfrom:yto);

[xfrom,xto,yfrom,yto] = getClampedImagePatchCordinates(maxxIndex,maxyIndex, filterSizeByTwo,size(im));

imgmax = im(xfrom:xto,yfrom:yto);

[r,c] = find(fim{1} <= 0.9 * minvalue);


imagePatchfig = figure;

subplot(2,1,1);imshow(imgmin,[]);title('Image patch giving maximum negative filter response');
subplot(2,1,2);imshow(imgmax,[]);title('Image patch giving maximum positive filter response');


saveas(imagePatchfig,strcat(outfolderName,outfilename),'fig');

