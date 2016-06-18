clear all;
clc
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-1\result-linear.mat','ap');
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-2\result-linear.mat','ap');
%ap = load('C:\DTD\experiments\ex-dtd-fv-dsift-seed-1\result-linear.mat','ap');
%aptexton = load('C:\DTD\                                                                                                                                                                                                                                                                                                                                                                                                                                                \ex-dtd-bovw-dsift-seed-3\result-linear.mat','ap');
%aptexton = load('C:\DTD\experiments\ex-dtd-fv-texton-seed-2\result-linear.mat','ap');
aptexton200 = load('C:\DTD\experimentsServerk200random\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');
aptexton100 = load('C:\DTD\experimentsServerk100random\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');

aptexton300 = load('C:\DTD\experimentsServerk300random\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');
aptexton400 = load('C:\DTD\experimentsServerk400random\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');
aptexton500 = load('C:\DTD\experimentsServerk500random\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');
aptexton200cluster512 = load('C:\DTD\experimentsServer200random512cluster\ex-dtd-fv-texton-seed-1\result-linear.mat','ap');


disp(mean(aptexton100.ap));
disp(mean(aptexton200.ap));
disp(mean(aptexton300.ap));
disp(mean(aptexton400.ap));
disp(mean(aptexton500.ap));
disp(mean(aptexton200cluster512.ap));

n = 0;

compare1 =aptexton200cluster512.ap;
compare2 = aptexton100.ap;

x = [compare1;compare2];
h = bar(x','grouped');
l{1} = 'k = 100';l{2} = ' k=200';
%legend(h,l);


[rind,cind] = find( compare1 - compare2 > 0 );

imdb = load('C:\DTD\dtd-r1.0.1.tar\dtd-r1.0.1\dtd\imdb\imdb.mat');
for i = 1:size(cind,2)
    
    fprintf(1,'%s; %.2f\n',imdb.meta.classes{cind(i)},  compare1( cind(i) ) - compare2(cind(i) )  );
end

%x = [ap.ap(aptexton.ap - ap.ap > 0);aptexton.ap(aptexton.ap - ap.ap > 0)];

%h = bar(x','grouped');
legend(h,l);
set(h(1),'FaceColor',[0,1,0])
set(h(2),'FaceColor',[1,0,1])
