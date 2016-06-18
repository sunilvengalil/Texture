function feat = select_representative_features(numDescrsPerImage,features)
    randn('state',0) ;
    rand('state',0) ;
    d = size(features.descr,1);
    md = mahal( features.descr', features.descr' );
    stdmd = std(md);
    threshold = mean(md) ;
    
    i = 0;
    while  i <=  numDescrsPerImage
       sel = find(md <= threshold);
       if(length(sel) >  numDescrsPerImage)
           rsel =  vl_colsubset(1:size(sel),10 *  numDescrsPerImage);
           feat =features.descr(:, sel(rsel));
           distance = dist(feat);
           stddistance =std(distance(:));
           distancethreshold = mean(mean(distance)) + 3 * stddistance;
           indices = find(distance>distancethreshold)
           
           if size(indices) > 0
              % select all features with indices
           end
    
    
    
       end
       threshold = threshold + stdmd;
    end
    
    
    
    
    
    
    if( size(sel) > numDescrsPerImage  )
        feat = features.descr(:,sel);
        distance = dist(feat);
         distancethreshold = mean(mean(distance)) + 2  * std(distance(:));
        if(size(sel) >  numDescrsPerImage)
              rsel = vl_colsubset(1:size(sel), numDescrsPerImage ) ;
              feat =features.descr(:, sel(rsel));
              
              distannce>distancethreshold
              
              
        end
        
        
       
        
      
        
    end
    
    
    
    X = features.descr(:,sel) ;
    mdsel = md(sel);
      
    feat = zeros(numDescrsPerImage,d);
    
    i =  0;
    while  i <= numDescrsPerImage
        
        [mdselv, mdseli] =  mdsel(d);
        
        while mesel(mdseli) < threshold
            i = i + 1;
           feat(i,:) = features.descr(sel( mdseli)); 
        end
        
      
       x = features.descr(:,i);
        % Compute mahalanobis distance from mean to x
        
        % if disance greater than threshold leave out this point
        
        %
        
    end
    
    %TODO what is parameter ann?
    %feat =  vl_kmeans(features.descr, numDescrsPerImage, 'algorithm', 'ann') ;
    
    
    
    %TODO find closest datapoints
end
