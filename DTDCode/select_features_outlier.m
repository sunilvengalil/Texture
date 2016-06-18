function feat = select_features_outlier(numDescrsPerImage,features)
    randn('state',0) ;
    rand('state',0) ;
    d = size(features.descr,1);
    md = mahal( features.descr', features.descr' );
    stdmd = std(md);
    threshold = mean(md) ;
    
    i = 0;
    while  i <  numDescrsPerImage
       sel = find(md <= threshold);
       if(length(sel) >  numDescrsPerImage)
           rsel =  vl_colsubset(1:size(sel),  numDescrsPerImage);
           feat =features.descr(:, sel(rsel));
           i = size(feat,2);
       end
       threshold = threshold + stdmd;
    end
   
end
