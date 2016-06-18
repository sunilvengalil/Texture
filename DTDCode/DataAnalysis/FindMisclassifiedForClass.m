
%Find scores for DTD Dataset
%Author: Sunil Kumar Vengalil

clear all;
close all;

cd C:\DTD;
% opts.modelPath = 'C:\DTD\data\dtd\model\fv';
% opts.resultDir = 'C:\DTD\data\dtd\result\fv';

% opts.modelPath = 'C:\DTD\data\dtd\model\textonabs';
% opts.resultDir = 'C:\DTD\data\dtd\result\textonabs';

% opts.modelPath = 'C:\DTD\data\dtd\model\texton';
% opts.resultDir = 'C:\DTD\data\dtd\result\texton';

% opts.modelPath = 'C:\DTD\data\dtd\model\fvtextonabs';
% opts.resultDir = 'C:\DTD\data\dtd\result\fvtextonabs';

modelPath = 'C:\DTD\experiments\ex-dtd-fv-texton-seed-2';
resultDir = 'C:\DTD\data\dtd\result\';
cacheDir = 'C:\DTD\experiments\ex-dtd-fv-texton-seed-2\cache';

%opts.prefix = 'texton3scaleabs' ;
%opts.prefix = 'texton3scale3clusterabs';
%opts.prefix = 'fv' ;
opts.prefix = 'textonEncoder';


opts.kernel = 'linear';
opts.C = 10 ;
opts.ntex = 3;

%opts.modelPath = strcat(modelPath,opts.prefix);
opts.resultDir = strcat(resultDir,opts.prefix);
%opts.cacheDir = strcat(cacheDir,opts.prefix);
% Load the metadata of dataset
imdb = load('C:\DTD\dtd-r1.0.1.tar\dtd-r1.0.1\dtd\imdb\imdb.mat');

numTrain = 5000;
train = vl_colsubset(find(imdb.images.set <= 2), numTrain, 'uniform') ;
paths = cellfun(@(S) fullfile(imdb.imageDir, S), imdb.images.name(train), ...
      'Uniform', 0);
encPath = 'C:\DTD\data\dtd\encoder\fv\encoder.m';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Use Fisher Vector encoding%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
 
% fv_encoder = load_encoder(encPath);
% fvCache = opts.cacheDir; 
% fv_descrs = encodeImage(fv_encoder, cellfun(@(S) fullfile(imdb.imageDir, S), ...
%      imdb.images.name, 'Uniform', 0), 'cacheDir', fvCache) ;
 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Use Modified Texton Encoding%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

texton_encoder = load_encoder(encPath);
texton_encoder.extractorFn = @(x)GetFilterFeatures(x);
textonCache = opts.cacheDir;

im=cellfun(@(S) fullfile(imdb.imageDir, S), ...
    imdb.images.name, 'Uniform', 0);
%  TODO fix this pass as a parameter 'ntex',opts.ntex
texton_descrs = encodeImageTexton(texton_encoder, im, 'cacheDir', textonCache) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Use Texton Encoding%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% opts.cacheDir = 'C:\DTD\data\dtd\cache\texton';
% texton_encoder = load_encoder(encPath);
% textonCache = opts.cacheDir;
% 
% im=cellfun(@(S) fullfile(imdb.imageDir, S), ...
%     imdb.images.name, 'Uniform', 0)
% texton_descrs = encodeImageTexton(texton_encoder, im, 'cacheDir', textonCache) ;

 

%%%%%%%%%%%%%%%%%%%%%%%
%Form the final descriptor
%%%%%%%%%%%%%%%%%%%%%%%%%

descrs = texton_descrs;

%descrs = cat(1, fv_descrs, texton_descrs);


if isfield(imdb.images, 'class')
  classRange = unique(imdb.images.class) ;
else
  classRange = 1:numel(imdb.classes.imageIds) ;
end
numClasses = numel(classRange) ;

switch opts.kernel
  case 'linear'
  case 'hell'
    descrs = sign(descrs) .* sqrt(abs(descrs)) ;
  case 'chi2'
    descrs = vl_homkermap(descrs,1,'kchi2') ;
  otherwise
    assert(false) ;
end

descrs = bsxfun(@times, descrs, 1./sqrt(sum(descrs.^2))) ;

% train and test
% 1 - training data; 2 - validation; 3 - test;
% for training, we use train+val
train = find(imdb.images.set <= 2) ;
test = find(imdb.images.set == 3) ;

lambda = 1 / (opts.C*numel(train)) ;
par = {'Solver', 'sdca', 'Verbose', ...
       'BiasMultiplier', 1, ...
       'Epsilon', 0.001, ...
       'MaxNumIterations', 100 * numel(train)} ;

scores = cell(1, numel(classRange)) ;
ap = zeros(1, numel(classRange)) ;
ap11 = zeros(1, numel(classRange)) ;
w = cell(1, numel(classRange)) ;
b = cell(1, numel(classRange)) ;
for c = 1:numel(classRange)
  if isfield(imdb.images, 'class')
    y = 2 * (imdb.images.class == classRange(c)) - 1 ;
  else
    y = - ones(1, numel(imdb.images.id)) ;
    [~,loc] = ismember(imdb.classes.imageIds{classRange(c)}, imdb.images.id) ;
    y(loc) = 1 - imdb.classes.difficult{classRange(c)} ;
  end
  if all(y <= 0), continue ; end

  [w{c},b{c}] = vl_svmtrain(descrs(:,train), y(train), lambda, par{:}) ;
  scores{c} = w{c}' * descrs + b{c} ;

  [~,~,info] = vl_pr(y(test), scores{c}(test)) ;
  ap(c) = info.ap ;
  ap11(c) = info.ap_interp_11 ;
  fprintf('class %s AP %.2f; AP 11 %.2f\n', imdb.meta.classes{classRange(c)}, ...
          ap(c) * 100, ap11(c)*100) ;
end
scores = cat(1,scores{:}) ;
% -------------------------------------------------------------------------


diary off ;
diary on ;

% confusion matrix (can be computed only if each image has only one label)
if isfield(imdb.images, 'class')
  [~,preds] = max(scores, [], 1) ;
  confusion = zeros(numClasses) ;
  for c = 1:numClasses
    sel = find(imdb.images.class == classRange(c) & imdb.images.set == 3) ;
    tmp = accumarray(preds(sel)', 1, [numClasses 1]) ;
    tmp = tmp / max(sum(tmp),1e-10) ;
    confusion(c,:) = tmp(:)' ;
  end
else
  confusion = NaN ;
end

save(opts.modelPath, 'w', 'b') ;

save(fullfile(opts.resultDir, sprintf('result-%s.mat', opts.kernel)), ...
     'scores', 'ap', 'ap11', 'confusion', 'classRange', 'opts') ;


% figures
meanAccuracy = sprintf('mean accuracy: %f\n', mean(diag(confusion)));
mAP = sprintf('mAP: %.2f %%; mAP 11: %.2f', mean(ap) * 100, mean(ap11) * 100) ;

if (1 == nargout)
  results.mAP = mean(ap);
  results.mAcc = mean(diag(confusion));
end



figure(1) ; clf ;
imagesc(confusion) ; axis square ;
title([opts.prefix ' - ' meanAccuracy]) ;
vl_printsize(1) ;
print('-dpdf', fullfile(opts.resultDir, sprintf('result-confusion-%s.pdf', ...
  opts.kernel))) ;
print('-djpeg', fullfile(opts.resultDir, sprintf('result-confusion-%s.jpg', ...
  opts.kernel))) ;
figure(2) ; clf ; bar(ap * 100) ;
title([opts.prefix ' - ' mAP]) ;
ylabel('AP %%') ; xlabel('class') ;
grid on ;
vl_printsize(1) ;
ylim([0 100]) ;
print('-dpdf', fullfile(opts.resultDir, sprintf('result-ap-%s.pdf', ...
  opts.kernel))) ;
print('-djpeg', fullfile(opts.resultDir, sprintf('result-ap-%s.jpg', ...
  opts.kernel))) ;

disp(meanAccuracy) ;
disp(mAP) ;
diary off ;

if isfield(imdb.images, 'class')
  [~,preds] = max(scores, [], 1) ;
  %confusion = zeros(numClasses) ;
  for cc = 1:numClasses
    sel = find(imdb.images.class == classRange(cc) & imdb.images.set == 3) ;
    %sel_wrong = (preds
  end
else
  confusion = NaN ;
end
