clear all;
clc
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-1\result-linear.mat','ap');
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-2\result-linear.mat','ap');
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-1\result-linear.mat','ap');
%aptexton = load('C:\DTD\                                                                                                                                                                                                                                                                                                                                                                                                                                                \ex-dtd-bovw-dsift-seed-3\result-linear.mat','ap');
%aptexton = load('C:\DTD\experiments\ex-dtd-fv-texton-seed-2\result-linear.mat','ap');
aptexton1 = load('C:\DTD\experiments\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');

n = 0;
maxsiftseed = 0;
maxtextonseed =0;
noOfSiftRun = 6 ;
noOfTextonRun = 6;  
apsift= zeros(noOfSiftRun,47);
aptexton = zeros(noOfTextonRun,47);
for  siftseed=1:noOfSiftRun
    t = load(strcat('C:\DTD\experimentsOld\ex-dtd-fv-dsift-seed-',num2str(siftseed),'\result-linear.mat' ),'ap');
    apsift(siftseed,:) = t.ap;
end

% for textonseed=1:noOfTextonRun
%         t = load(strcat('C:\DTD\experiments\ex-dtd-fv-texton-seed-',num2str(textonseed),'\result-linear.mat' ),'ap');
%         aptexton(textonseed,:) = t.ap;
% end

mapsift = min(apsift);

      


x = [mapsift;aptexton1.ap];
h = bar(x','grouped');
l{1} = 'sift + fv';l{2} = 'texton + fv';
%legend(h,l);


[rind,cind] = find( aptexton1.ap - mapsift > 0 );

imdb = load('C:\DTD\dtd-r1.0.1.tar\dtd-r1.0.1\dtd\imdb\imdb.mat');
for i = 1:size(cind,2)
    
    fprintf(1,'%s; %.2f\n',imdb.meta.classes{cind(i)},  aptexton1.ap( cind(i) ) - mapsift(cind(i) )  );
end

%x = [ap.ap(aptexton.ap - ap.ap > 0);aptexton.ap(aptexton.ap - ap.ap > 0)];

%h = bar(x','grouped');
legend(h,l);
set(h(1),'FaceColor',[0,1,0])
set(h(2),'FaceColor',[1,0,1])
