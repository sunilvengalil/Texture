clc
clear all;
imdb = load('C:\DTD\dtd-r1.0.1.tar\dtd-r1.0.1\dtd\imdb\imdb.mat');
fid = fopen('C:\compre\dtdclasses.txt','w');
for i=1:15
    fprintf(fid,'%d & %s & %d & %s & %d & %s \\\\\r\n',i,imdb.meta.classes{i}, i+ 15,imdb.meta.classes{i+15},i+ 30,imdb.meta.classes{i+30});
    fprintf(fid,'\\hline\r\n');
end
fprintf(fid,'%d & %s & %d & %s & &  \\\\\r\n',46,imdb.meta.classes{46},47,imdb.meta.classes{47});
    fprintf(fid,'\\hline\r\n');
fclose(fid);