textonfig = figure;

plot(tex(:,1),'r');
hold on;
plot(tex(:,2),'g');


filterBankFig = figure;
numberOfFilters = length(tex(:,1));
for filterNumber = 1:numberOfFilters
    subplot(6,2,filterNumber);imshow(fb{filterNumber},[]);
end
