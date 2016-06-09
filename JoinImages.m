function  JoinImages(dtdClass1,dtdClass2,indices1,indices2,outDir )

bandedFiles = dir(dtdClass1);
scalyFiles = dir(dtdClass2);


for bandedIndex = 1:length(indices1);
    for scalyIndex = 1:length(indices2);
        im1 = imread(strcat(dtdClass1,'\',bandedFiles(indices1(bandedIndex) ).name));
        im2 = imread(strcat(dtdClass2,'\',scalyFiles(indices2(scalyIndex) ).name));
        
        [p,n,e] = fileparts(bandedFiles(indices1(bandedIndex) ).name);
        [p1,n1,e1] = fileparts(scalyFiles(indices2(scalyIndex) ).name);
        outfileName = strcat(n,'_',n1,e);
        
        height = min(size(im1,1),size(im2,1) );
        width = min(size(im1,2),size(im2,2) );
        
        
        imwrite([im1(1:height,1:width);im2(1:height,1:width)],strcat(outDir,outfileName) );
    end
    
end



end

