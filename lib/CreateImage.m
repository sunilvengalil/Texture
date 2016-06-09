function [ im ] = CreateImage(width,height, n1,  n2  )
%CreateImage create an image of size width X height
% n1 points belonging to and n2 points belonging to class 2

im = ones(height,width,3);

centerCluster1 = [height/2, width/4];
centerCluster2 = [height/2,3 * width/4];

%im(centerCluster1(1)-5: centerCluster1(1)+5, centerCluster1(2) - 5:centerCluster1(2) + 5 ,2) = 0; 
im(centerCluster1(1),centerCluster1(2),2:3) = 0;

%im(centerCluster1, centerCluster2,3) = 0;


mu = centerCluster1;
Sigma = [20 0; 0 20];
F = mvnrnd(mu,Sigma,n1);

for n = 1:n1
    % place a data point at (j,i)
    p = uint8(F(n,:));
    
    %im(p(1)-5: p(1)+5, p(2) - 5:p(2) + 5 ,2) = 0;
    im( p(1),p(2),2) = 0;
    
end

%generate points for cluster 2


im(centerCluster2(1),centerCluster2(2),1:2 ) = 0;
%im(centerCluster1, centerCluster2,3) = 0;


mu = centerCluster2;
Sigma = [20 0; 0 20];
F = mvnrnd(mu,Sigma,n2);

for n = 1:n2
    % place a data point at (j,i)
    p = uint8(F(n,:));
    
    %im(p(1)-5: p(1)+5, p(2) - 5:p(2) + 5 ,2) = 0;
    im( p(1),p(2),1:2) = 0;
    
end





end

