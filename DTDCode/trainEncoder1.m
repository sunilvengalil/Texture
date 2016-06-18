function encoder = trainEncoder1(images, varargin)
% TRAINENCODER   Train image encoder: BoVW, VLAD, FV
%   ENCODER = TRAINENCOER(IMAGES) trains a BoVW encoder from the
%   specified list of images IMAGES.
%
%   TRAINENCODER(..., 'OPT', VAL, ...) accepts the following options:
%
%   Type:: 'bovw'
%     Bag of visual words ('bovw'), VLAD ('vlad') or Fisher Vector
%     ('fv').
%
%   numPcaDimension:: +inf
%     Use PCA to reduce the descriptor dimensionality to this
%     dimension. Use +inf to deactivate PCA.
%
%   Whitening:: false
%     Set to true to divide the principal components by the
%     corresponding standard deviation s_i.
%
%   WhiteningRegul:: 0
%     When using whitening, divide by s_max * WhiteningRegul + s_i
%     instead of s_i alone.
%
%   Renormalize:: false
%     If true, descriptors are L2 normalized after PCA or
%     whitening.
%
%
%   Subdivisions:: []
%     A list of spatial subdivisions. Each column is a rectangle
%     [XMIN YMIN XMAX YMAX]. The spatial subdivisions are
%
%   Layouts:: {'1x1'}
%     A list of strings representing regular spatial subdivisions
%     in the format MxN, where M is the number of vertical
%     subdivisions and N the number of horizontal ones. For
%     example {'1x1', 2x2'} uses 5 partitions: the whole image and
%     four quadrants. The subdivisions are appended to the ones
%     speified by the SUBDIVISIONS option.
%
%   ReadImageFn:: @readImage
%     The function used to load an image.
%
%   ExtractorFn:: @getDenseSIFT
%     The function used to extract the feature frames and
%     descriptors from an image.

% Author: Andrea Vedaldi

% Copyright (C) 2013 Andrea Vedaldi
% All rights reserved.
%
% This file is part of the VLFeat library and is made available under
% the terms of the BSD license (see the COPYING file).

opts.type = 'bovw' ;
opts.numWords = [] ;
opts.seed = 1 ;
opts.numPcaDimensions = +inf ;
opts.whitening = false ;
opts.whiteningRegul = 0 ;
opts.numSamplesPerWord = [] ;
opts.renormalize = false ;
opts.layouts = {'1x1'} ;
opts.subdivisions = zeros(4,0) ;
opts.readImageFn = @readImage1;
opts.extractorFn = @getDenseSIFT ;
opts.lite = false ;
opts.useMasks = false;
%opts.resize = 'original';
opts.resize = '300x300';
opts = vl_argparse(opts, varargin) ;

if (~isfield(opts, 'useMasks'))
  opts.useMasks = false;
end

for i = 1:numel(opts.layouts)
  t = sscanf(opts.layouts{i},'%dx%d') ;
  m = t(1) ;
  n = t(2) ;
  [x,y] = meshgrid(...
    linspace(0,1,n+1), ...
    linspace(0,1,m+1)) ;
  x1 = x(1:end-1,1:end-1) ;
  y1 = y(1:end-1,1:end-1) ;
  x2 = x(2:end,2:end) ;
  y2 = y(2:end,2:end) ;
  opts.subdivisions = cat(2, opts.subdivisions, ...
    [x1(:)' ;
     y1(:)' ;
     x2(:)' ;
     y2(:)'] ) ;
end

if (strcmp(opts.resize, 'original'))
  scaling = 0;
else
  scl = sscanf(opts.resize, '%dx%d');
  scaling = scl(1); % support only a square
end

if isempty(opts.numWords)
    switch opts.type
      case {'bovw'}
        opts.numWords = 1024 ;
      case {'fv'}
        opts.numWords = 64 ;
        opts.numPcaDimensions = 80 ;
      case {'vlad'}
        opts.numWords = 64 ;
        opts.numPcaDimensions = 100 ;
        opts.whitening = true ;
        opts.whiteninRegul = 0.01 ;
      case {'llc', 'kcb'}
        opts.numWords = 10000;
        opts.norm_type = 'l2';
        opts.max_comps = -1;
        opts.num_nn = 5;
        opts.beta = 1e-4;
      case {'raw', 'mix'}
      otherwise
        assert(false) ;
    end
end

if isempty(opts.numSamplesPerWord)
    switch opts.type
      case {'bovw'}
        opts.numSamplesPerWord = 200 ;
      case {'vlad','fv'}
        opts.numSamplesPerWord = 1000 ;
      case {'llc', 'llc10k'}
        opts.numSamplesPerWord = 200;
      case {'kcb', 'kcb10k'}
        opts.numSamplesPerWord = 200;
      case {'raw', 'mix'}
        opts.numSamplesPerWord = 0;
      otherwise
        assert(false) ;
    end
    if opts.lite
      opts.numSamplesPerWord = 10 ;
    end
end

disp(opts) ;

encoder.type = opts.type ;
encoder.subdivisions = opts.subdivisions ;
encoder.readImageFn = opts.readImageFn ;
encoder.extractorFn = opts.extractorFn ;
encoder.numWords = opts.numWords ;
encoder.renormalize = opts.renormalize ;

if (strcmp(encoder.type, 'raw') || strcmp(encoder.type, 'mix'))
  return;
end

%% Step 0: obtain sample image descriptors
max_descrs = 200000000;
numImages = numel(images) ;
%numDescrsPerImage = ceil(min(max_descrs, opts.numWords * opts.numSamplesPerWord) / numImages) ;
numDescrsPerImage = 100;
useMasks = opts.useMasks;
for i = 1:numImages
  featuresFolderName = strcat('features-',num2str(opts.seed));
  featureFileName = strrep(images{i},'images',featuresFolderName);
  featureFileName = strrep(featureFileName,'jpg','mat');
  if exist(featureFileName,'file')
      fprintf('%s: loading features from : %s\n', featureFileName, images{i}) ;
      data = loadFeatures(featureFileName);
  else
      [p,n] = fileparts(featureFileName);
      if not(exist(p,'dir') )
        vl_xmkdir(p);
      end
      
      fprintf('%s: reading: %s\n', mfilename, images{i}) ;
      im = encoder.readImageFn(images{i}, scaling) ;
      w = size(im,2) ;
      h = size(im,1) ;
     features = encoder.extractorFn(im) ;
     data = select_representative_features(numDescrsPerImage,features);
     %data = select_features_outlier(numDescrsPerImage,features);
     save(featureFileName,'data'); 
  end
    
   
  descrs{i} = data;
  clear data;
  
%   frames{i} = features.frame(:,sel) ;
%   frames{i} = bsxfun(@times, bsxfun(@minus, frames{i}(1:2,:), [w;h]/2), 1./[w;h]) ;
end

fprintf('concatenating descriptors');
descrs = cat(2, descrs{:}) ;
%frames = cat(2, frames{:}) ;

%% Step 1 (optional): learn PCA projection
if opts.numPcaDimensions < inf || opts.whitening
  fprintf('%s: learning PCA rotation/projection\n', mfilename) ;
  encoder.projectionCenter = mean(descrs, 2) ;
  x = bsxfun(@minus, descrs, encoder.projectionCenter) ;
  X = x*x' / size(x,2) ;
  [V,D] = eig(X) ;
  d = diag(D) ;
  [d,perm] = sort(d,'descend') ;
  d = d + opts.whiteningRegul * max(d) ;
  m = min(opts.numPcaDimensions, size(descrs,1)) ;
  V = V(:,perm) ;
  if opts.whitening
    encoder.projection = diag(1./sqrt(d(1:m))) * V(:,1:m)' ;
  else
    encoder.projection = V(:,1:m)' ;
  end
  clear X V D d ;
else
  encoder.projection = 1 ;
  encoder.projectionCenter = 0 ;
end
descrs = encoder.projection * bsxfun(@minus, descrs, encoder.projectionCenter) ;
if encoder.renormalize
  descrs = bsxfun(@times, descrs, 1./max(1e-12, sqrt(sum(descrs.^2)))) ;
end

%% Step 2: learn a VQ or GMM vocabulary
dimension = size(descrs,1) ;
numDescriptors = size(descrs,2) ;

switch encoder.type
  case {'bovw', 'vlad', 'llc10k', 'kcb10k'}
    vl_twister('state', opts.seed) ;
    encoder.words = vl_kmeans(descrs, opts.numWords, 'verbose', 'algorithm', 'ann') ;
    encoder.kdtree = vl_kdtreebuild(encoder.words, 'numTrees', 2) ;

  case {'fv'} ;
    vl_twister('state', opts.seed) ;
    if 1
      v = var(descrs')' ;
      fprintf('Learning dictionary words');
      [encoder.means, encoder.covariances, encoder.priors] = ...
          vl_gmm(descrs, opts.numWords, 'verbose', ...
                 'Initialization', 'kmeans', ...
                 'CovarianceBound', double(max(v)*0.0001), ...
                 'NumRepetitions', 1) ;
    else
      addpath lib/yael/matlab
      [a,b,c] = ...
          yael_gmm(descrs, opts.numWords, 'verbose', 2) ;
      encoder.priors = single(a) ;
      encoder.means = single(b) ;
      encoder.covariances = single(c) ;
    end
end
