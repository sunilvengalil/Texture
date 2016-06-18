clc;
clear all;
imdb = load('C:\DTD\dtd-r1.0.1.tar\dtd-r1.0.1\dtd\imdb\imdb.mat');
load('C:\DTD\data\dtd\result\textonabs\result-linear.mat','ap')
[m,i]  = sort(ap,'descend');
for ind = 1:47
   fprintf(1,'%s; %.2f\n',imdb.meta.classes{i(ind)},  m(ind)  )
end

