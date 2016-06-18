function feat = select_representative_features(numDescrsPerImage,features)
    %randn('state',0) ;
    
    sel = vl_colsubset(1:size(features.descr,2), single(numDescrsPerImage)) ;
    feat = features.descr(:,sel) ;
    
    %TODO what is parameter ann?
    %feat =  vl_kmeans(features.descr, numDescrsPerImage, 'algorithm', 'ann') ;
    
    %feat = mean(features.descr,2);
    
    %TODO find closest datapoints
end
